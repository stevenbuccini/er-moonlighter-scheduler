class ShiftsController < ApplicationController
  before_filter :authenticate_user! # Redirects if user isn't signed in

  def update
  	flash.keep
  	flash[:alert] = "You just signed up for the following shifts: "
  	shifts = params["post"]["shifts"]
  	shifts.each do |shift_id|
  		current_shift = Shift.find(shift_id)
  		current_shift.book(@current_user)
  		current_shift.save!
  		flash[:alert] = flash[:alert]+ current_shift + ", "
  	end

  	redirect_to '/'
  end

end