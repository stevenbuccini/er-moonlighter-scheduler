class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # Overriding the built-in Devise method to have people edit their info.
  def after_sign_in_path_for(user)
  	edit_user_path(current_user.id)
  end
end
