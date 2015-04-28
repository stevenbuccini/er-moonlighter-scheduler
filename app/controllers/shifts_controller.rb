class ShiftsController < ApplicationController
  before_filter :authenticate_user! # Redirects if user isn't signed in

  def update
    shifts = params["post"]["shifts"]
    errors = Shift.assign_shifts(shifts, current_user)
    if errors[:failed_save]
      flash[:error] = errors[:failed_save]
    else
      flash[:notice] = "You successfully signed up for your requested shifts!"
    end
    # These are shifts that we could not assign because they had already been
    # assigned to another user.
    #It will be the view's responsibility to loop through these
    # and to correctly display the error message. 
    @claimed_shifts = errors[:claimed_shifts]
    redirect_to '/'
  end
end