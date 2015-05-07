class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?



	# Overriding the built-in Devise method to have people edit their info.
  def after_sign_in_path_for(user)
    if user.registration_complete
  	  dashboard_index_path
    else
      edit_user_registration_path
    end
  end

  #*********************************************************************************
  #*************DEFINE GENERAL HELPER METHODS HERE *********************************
  #*********************************************************************************
  def destroy_helper(user, path, model_name)
    user.destroy
    respond_to do |format|
      format.html { redirect_to path, notice: "#{model_name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def check_users_authorization_helper(type)
    if current_user.type != type
      flash[:alert] = "You are not authorised to perform this action"
      redirect_to :controller => 'dashboard', :action => 'view'
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name, :phone_1, :phone_2, :phone_3, :comments]
  end

  # Use this view if you want to restrict 
  def admin_only_view
    if !current_user.is_a? Admin and current_user.type != "AdminAssistant"
      flash[:error] = "You are not authorized to view this page."
      redirect_to :root
      # Explictly tell the caller that this check failed
      return false
    else
      # Explictly tell the caller that this check was successful
      return true
    end
  end

  # Use this view if you want to ensure that a particular action is available
  # only to people who have been explicitly whitelisted by an admin.
  def doctor_or_admin_view
    if !((current_user.is_a? Doctor) || (current_user.is_a? Admin) || (current_user.is_a? AdminAssistant))
      flash[:error] = "You are not authorized to view this page."
      redirect_to :root
      # Explictly tell the caller that this check failed
      return false
    else
      # Explictly tell the caller that this check was successful
      return true
    end
  end 
  def update_helper(model, model_name, params)
    respond_to do |format|
      if model.update(params)
        format.html { redirect_to model, notice: "#{model_name} was successfully updated." }
        format.json { render :show, status: :ok, location: model }
      else
        format.html { render :edit }
        format.json { render json: model.errors, status: :unprocessable_entity }
      end
    end   
  end
end
