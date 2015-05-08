class DashboardController < ApplicationController
  before_filter :authenticate_user! # redirect if user isn't signed in

	def index
		if current_user.type
	  	if current_user.type == Doctor.NAME 
				redirect_to :controller => 'doctors', :action => 'index'
			elsif current_user.type == Admin.NAME or current_user.type == "AdminAssistant" 
				redirect_to :controller => 'admins', :action => 'index'
			end
		end
	end

  def view
  end
end