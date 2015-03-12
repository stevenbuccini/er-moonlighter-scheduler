class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?



	# Overriding the built-in Devise method to have people edit their info.
  def after_sign_in_path_for(user)
  	edit_user_registration_path
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]
  end

  # Use this view if you want to restrict 
  def admin_only_view
    if !current_user.is_a? Admin
      render html: "<h1>403 - Not Authorized</h1".html_safe
    end
  end

  # Use this view if you want to ensure that a particular action is available
  # only to people who have been explicitly whitelisted by an admin.
  def doctor_or_admin_view
    if !((current_user.is_a? Doctor) || (current_user.is_a? Admin))
      render html: "<h1>403 - Not Authorized</h1".html_safe
    end
  end 
end
