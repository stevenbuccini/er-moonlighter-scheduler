class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! # redirect if user isn't signed in
  before_filter :check_users_authorization, :except => [:destroy, :contact_list, :create_email]# redirect if user is not an admin
  before_filter :doctor_or_admin_view, only: [:contact_list, :create_email, :send_email]

  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all
    @doctors = Doctor.all
    @shifts = Shift.all
    @users_awaiting_approver = User.where(:type =>nil)
    @current_pay_period = PayPeriod.find_by_id current_user.pay_period_id
  end

  def contact_list
    @admins = Admin.all
    @doctors = Doctor.all
    render 'partials/_contact_list'
  end

  def pending_users
    @users_awaiting_approver = User.where(:type =>nil)
    render 'partials/_pending_users'
  end

  def assign_doc_to_shift
    @shifts =  Shift.where(:pay_period => PayPeriod.where(phase:"1"), confirmed: false)
  end
  # GET /admins/1
  # GET /admins/1.json
  def show
  end

  def confirm_shift
    shift = Shift.find(params[:shift])
    # if @shift
      flash= shift.confirm_shift(params[:candidate])
    # end
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  def create_email
    @doctors = Doctor.all
    @pay_periods = PayPeriod.get_open
  end

  def send_email
    if params[:activated] == nil || params[:activated] == ""
      flash[:notice] = "Please select doctors you want to send emails to"
      redirect_to '/create-email'
    #params[:pay_period] ||= " "
    else
      @doctors = Doctor.find(params[:activated])
      if params[:pay_period]
        params[:pay_period] = "#{params[:pay_period]['start']} to #{params[:pay_period]['end']}"
      end
      sent_to = "Email sent to: " + Admin.get_doctor_names(@doctors)
      @doctors.each do |doctor|
        current_user.send_email(doctor, params)
      end
      flash[:notice] = sent_to
      redirect_to '/'
    end
  end

  def update
    update_helper(@admin, "Admin", admin_params)
  end


  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    destroy_helper(@admin, admins_url, "Admin")
  end


  def approve_doctor
    approve_user("Doctor")
  end

  def approve_new_admin
    approve_user("Admin")
  end
  def approve_admin_assist
    approve_user("AdminAssistant")
  end

  #To create a new payperiod for doctors and admins
  #After successful creation, current_pay_period is updated for both admins and doctor to the newly created payperiod
  def create_new_pay_period
    redirect_to :controller => 'pay_periods' , :action => 'new' and return
  end


  #To create a new payperiod for doctors
  def edit_current_pay_period
    redirect_to :controller => 'pay_periods', :action => 'edit' , :id => 1 and return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
      #needs to redirect if fails
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.require(:admin).permit(:first_name, :last_name, :phone_1, :phone_2, :phone_3, :comments)
    end
    def check_users_authorization
      check_users_authorization_helper(Admin.NAME)
    end

    #TODO:
    def approve_user(user_type)
       @user = User.find_by_id params[:user]
      if @user
        @user.update_attribute(:type, user_type)
        flash[:notice] = "Approved #{@user.first_name} as a #{user_type}!"
      end
    end

    def is_not_nil
      if current_user.type != nil
        return true
      end
      return false
    end
end
