class ShiftsController < ApplicationController
  before_filter :authenticate_user! # Redirects if user isn't signed in

  def update
    shifts = params["post"]["shifts"]
    errors = Shift.sign_up(shifts, current_user)
    if errors[:failed_save]
      flash[:error] = errors[:failed_save]
    elsif errors[:claimed_shifts].present?
      # These are shifts that we could not assign because they had already been
      # assigned to another user.
      # It will be the view's responsibility to loop through these
      # and to correctly display the error message. 
      # We have to put these in the session because we're redirecting back to the
      # index and those variables aren't persisted across requests.
      session[:claimed_shifts] = errors[:claimed_shifts]
      flash[:notice] = "We saved some shifts, but there were errors with others."
    else
      flash[:notice] = "You successfully signed up for your requested shifts!"
    end

    # NOTE: If you change where this method redirects to, you also need to move
    # the rror div that loops through @claimed_shifts which is currently in the index.
    redirect_to doctors_path
  end
end