class DashboardController < ApplicationController
  before_filter :authenticate_user! # redirect if user isn't signed in

	def index
		if current_user.type
	  	if current_user.type == Doctor.NAME 
				redirect_to :controller => 'doctors', :action => 'index'
			elsif current_user.type == Admin.NAME
				redirect_to :controller => 'admins', :action => 'index'
			end
		else
				flash[:notice] = "Your account is waiting an admin's approval"
				redirect_to :action => 'view'
		end
	end

  def view
  	
  end
end