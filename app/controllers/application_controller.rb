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
    devise_parameter_sanitizer.for(:sign_up) << :email
    devise_parameter_sanitizer.for(:account_update) << [:email, :first_name, :last_name]
  end

end
