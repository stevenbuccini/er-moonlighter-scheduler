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

  def self.assign_multiple_shifts(array_of_ids, doctor)
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
end
