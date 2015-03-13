class DashBoardController < ApplicationController
	before_filter :authenticate_user! # redirect if user isn't signed in

	def index
		if current_user.type
	  	if current_user.type == "Doctor" 
				redirect_to :controller => 'doctors', :action => 'index'
			elsif current_user.type == "Admin"
				redirect_to :controller => 'admins', :action => 'index'
			end
		end
		flash[:notice] = "your account is waiting for admin's approver"
		redirect_to :action => 'show'
	end

  def show
  	
  end
end