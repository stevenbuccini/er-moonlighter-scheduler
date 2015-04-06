class ShiftsController < ApplicationController
  before_filter :authenticate_user! # Redirects if user isn't signed in

  def update
  	flash.keep
  	flash[:alert] = "You just signed up for the following shifts: "
    flash[:error] = ""
  	shifts = params["post"]["shifts"]
    failed_save = false # Will change to true if something fails to save properly.
  	shifts.each do |shift_id|
  		current_shift = Shift.find(shift_id)
  		current_shift.book(@current_user)
  		result = current_shift.save
      if result
  		  flash[:alert] = flash[:alert]+ current_shift + ", "
      elsif !result && !failed_save
        # First time save failed, do some setup
        failed_save = true
        flash[:error] = "One or more of the shifts failed to save: "
        # full_messages is a list of strings, join them together into one string
        # then add it to the errors flash.  Janky, but we shouldn't see this 
        # too often since our validations so
        flash[:error] += current_shift.errors.full_messages.join(" ")
      else
        flash[:error] += current_shift.errors.full_messages.join(" ")
      end
  	end

  	redirect_to '/'
  end

end