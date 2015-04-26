class Shift < ActiveRecord::Base

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

  private

  def self.create_shift_from_hash(data_hash, pay_period_id)
    # TODO: Tayo to renable after we figure out payment profile stuff.
    #data_hash[:pay_period_id] = pay_period_id

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

end
