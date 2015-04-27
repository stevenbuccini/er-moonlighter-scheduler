class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! # redirect if user isn't signed in
  before_filter :check_users_authorization, :except => [:destroy, :contact_list]# redirect if user is not an admin
  before_filter :admin_only_view, only: [:create_email, :send_email]
  before_filter :doctor_or_admin_view, only: [:contact_list]

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
  # GET /admins/1
  # GET /admins/1.json
  def show
    @admin = Admin.find(params[:id])
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])

  end

  def create_email
    @doctors = Doctor.all
  end

  def send_email
    if params[:activated] == nil || params[:activated] == ""
      flash[:notice] = "Please select doctors you want to send emails to"
      redirect_to '/create-email'
    else
      @doctors = Doctor.find(params[:activated])
      sent_to = "Email sent to: " + Admin.get_doctor_names(@doctors)
      @doctors.each do |doctor|
        current_user.send_email(doctor, params)
      end
      flash[:notice] = sent_to
      redirect_to '/'
    end
  end

  # POST /admins
  # POST /admins.json
  # def create
  #   @admin = Admin.new(admin_params)

  #   respond_to do |format|
  #     if @admin.save
  #       format.html { redirect_to @admin, notice: 'Admin was successfully created.' }
  #       format.json { render :show, status: :created, location: @admin }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @admin.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    @admin = Admin.find(params[:id])
    update_helper(@admin, "Admin", admin_params)
  end


  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    destroy_helper(@admin, admins_url, "Admin")
  end


  # def approve_doctor
  #   @user = User.find_by_id params[:user]
  #   if @user
  #     @user.update_attribute(:type, "Doctor")
  #     flash[:notice] = "Approved #{@user.first_name} as a doctor!"
  #   end
  # end

  def approve_doctor
    approve_user("Doctor")
    # @user = User.find_by_id params[:user]
    # if @user
    #   @user.update_attribute(:type, "Doctor")
    #   flash[:notice] = "Approved #{@user.first_name} as a doctor!"
    # end
  end

  def approve_new_admin
    approve_user("Admin")
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
