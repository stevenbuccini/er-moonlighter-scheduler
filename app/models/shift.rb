class Shift < ActiveRecord::Base
  serialize :candidates

  belongs_to :doctor
  belongs_to :pay_period

  after_initialize :init


  validates_presence_of :start_datetime, :end_datetime
  validate :start_datetime_must_be_before_end_datetime


  def init
    # This method gets called as a callback to any method that creates
    # an instance of this model, including find() !

    if new_record?
      self.confirmed = false
    end
  end

  def to_s
    self.start_datetime.strftime("%b %e,%l:%M %p") + " - " +  self.end_datetime.strftime("%b %e,%l:%M %p")
  end

  def to_str
    self.start_datetime.strftime("%b %e,%l:%M %p") + " - " +  self.end_datetime.strftime("%b %e,%l:%M %p")
  end

  def book(current_user)
    self.confirmed = true
    self.doctor = current_user
  end

  def start_datetime_must_be_before_end_datetime
    # Check for non-nil since the ">" operator is not defined for these functions.
    if start_datetime and end_datetime
      errors.add(:sanity_check, "end time can't be before the start time") if start_datetime > end_datetime
    end
  end

  # To help doctors sign up for shift. Since multiple doctors can signup for a shift in phase
  # argument: int doctors id
  def self.sign_up(array_of_ids, doctor)
    phase_two_shifts = []
    shifts = Shift.find(array_of_ids)
    if shifts.empty? 
      return assign_shifts(array_of_ids, doctor)
    end
    shifts.each do |s|
      p = PayPeriod.find_by_id s.pay_period_id
      if p and p.phase = "1"
        if s.candidates.nil?
          s.candidates = [doctor.id]
        else
          s.candidates << doctor.id 
        end
      else
        phase_two_shifts << s.id
      end
    end
    if !phase_two_shifts.empty?
      return assign_shifts(phase_two_shifts, doctor)
    end
    return {}
  end

  def self.assign_shifts(array_of_ids, doctor)
    # Bulk assign shifts. Return true if successful, false if save fails.
    transaction_errors = {}
    transaction_errors.default = nil
    # Declar vars here becuase Ruby has block scope
    taken_shifts = []
    shifts_to_update_ids = []
    # Wrap this in a transaction so we don't have race conditions.
    update_status = Shift.transaction do
      # Find shifts that have already been taken.
      shifts = Shift.find(array_of_ids)
      shifts.each do |s|
        if s.confirmed
          taken_shifts.push(s)
        else
          shifts_to_update_ids.push(s.id)
          s.doctor = doctor
          Calendar.gcal_event_update(s)
        end
      
      end
      Shift.where(id: shifts_to_update_ids).update_all({confirmed: true, doctor_id: doctor.id})

    end
    if !(taken_shifts.empty?)
      transaction_errors[:claimed_shifts] = taken_shifts
    end
    if !update_status
      transaction_errors[:failed_save] = "Failed to save shift assignments. Please try again."
    end
    return transaction_errors
  end


  def self.create_shifts_for_pay_period(start_datetime, end_datetime, pay_period_id)

    # Storing errors here so we can pass them back up to the front end.
    # On the front end, need to check 
    errors_hash = {}

    # Have to wrap this instance method because we can't call the class method direclty 
    api_response = Calendar.gcal_get_events_in_range(start_datetime, end_datetime)
    if api_response.status == 200
      # Request successful
      # Coerce GCal JSON into our own internal representation
      translated_json = Shift.parse_gcal_json(api_response)
      translated_json.each do |event_hash|
        errors = Shift.create_shift_from_hash(event_hash, pay_period_id)
        if errors
          errors_hash[:shift_save] ||= []
          errors_hash[:shift_save] << errors
        end
      end
    else
      # We ran into an error when we tried to talk to the Google Calendar API.
      # Put it in the error hash
      jsonified = JSON.parse(api_response.body)['error']
      errors_hash[:request_error] = "HTTP #{jsonified['code']} -- #{jsonified['message']}"
    end

    # Pass the errors back up to the front end
    return errors_hash
  end

  def self.delete_completed_shifts
    # We could just delete these right away, but we need to update the doctors `last_shift_completion_date` field.
    # This shouldn't be too expensive becuase there will be a maximum of like 20 shifts to delete at any given
    # time becuase we're just deleting the shifts from the previous 24 hours.


    # We fix this time because we only want to delete shifts for which we've updated the doctors,
    # and there is (albeit small) possiblity that a shift could have completed while we're running
    # this query
    fixed_time = DateTime.now
    completed_shifts = Shift.where("end_datetime <= ?", fixed_time)
    completed_shifts.each do |shift|
      doc = shift.doctor
      doc.last_shift_completion_date = shift.end_datetime.to_date #convert to date because it shouldn't matter at the exact time they stopped.
      doc.save
    end
    # Delete all shifts at once so we do less transactions.
    # NOTE: This does NOT invoke the callbacks nor does it use the destroy method.
    # This prevents instanation of each object a la destroy_all
    Shift.where("end_datetime <= ?", fixed_time).delete_all 
  end

  private

  def self.create_shift_from_hash(data_hash, pay_period_id)
    # TODO: Tayo to renable after we figure out payment profile stuff.
    data_hash[:pay_period_id] = pay_period_id
    s = Shift.create(data_hash)
    # If object is invalid, there were errors when saving.
    # Return them to the calling method for proper display on the view.
    if s.errors.present?
      return s.errors.full_messages.to_sentence
    end
    # Return nil if no errors
    return nil
  end

  def self.parse_gcal_json(api_response)
    # Coerce the keys from Google into our own internal representation
    translated_json = []

    list_of_event_json = JSON.parse(api_response.body)['items']
    # Now loop through this list, convert JSON to shifts, and save.
    list_of_event_json.each do |gcal_json|
      # Code smell, but sometimes the data we need is nested and so it's hard
      # to refactor this into a one-size-fits-all case.

      # Additionally, updating the model will be such a rare occurrance that
      # I think we can get away with this.
      translated_json << {
        start_datetime: DateTime.strptime(gcal_json['start']['dateTime']),
        end_datetime: DateTime.strptime(gcal_json['end']['dateTime']),
        gcal_event_etag: gcal_json['etag'],
        gcal_event_id: gcal_json['id'],
      }
    end
    return translated_json
  end

  def self.find_doctor_name(candidate_id)
    return Doctor.find(candidate_id).full_name
  end

  def self.find_requested_shifts(doctor_id)
    @shifts = Shift.where(confirmed: false)
    @return_shifts = []
    @shifts.each do |shift|
      if shift.candidates.include? doctor_id
        @return_shifts.append(shift)
      end
    end
    return @return_shifts
  end

end
