class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! # redirect if user isn't signed in
  before_filter :check_user_type, :except => :destroy# redirect if user is not an admin
  before_filter :admin_only_view, only: [:create_new_email, :send_mass_email]

  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all
    @doctors = Doctor.all
    @shifts = Shift.all
    @users_awaiting_approver = User.where(:type =>nil)
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

  def create_new_email
  end

  def send_mass_email
    @doctors = Doctor.all
    sent_to = "Email sent to: "
    @doctors.each do |doctor|
      if params.has_key?(:urgent)
        #UserMailer.send
        UserMailer.urgent_email(doctor).deliver_now
      elsif params.has_key?(:new_pay_period)
        UserMailer.new_pay_period_email(doctor).deliver_now
      else
        subject = params[:subject]
        text = params[:body]
        
          UserMailer.custom_email(doctor, subject, text).deliver_now
      end
      sent_to = sent_to + doctor.full_name + " "
    end
      
    
    flash[:notice] = sent_to
    redirect_to '/'
  end

  # POST /admins
  # POST /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: 'Admin was successfully created.' }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    @admin = Admin.find(params[:id])
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def approve_doctor
    @user = User.find_by_id params[:user]
    if @user
      @user.update_attribute(:type, "Doctor")
      flash[:notice] = "Approved #{@user.first_name} as a doctor!"
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
      #needs to redirect if fails
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.require(:admin).permit(:first_name, :last_name, :phone_1, :phone_2, :phone_3)
    end
    def check_user_type
      if current_user.type != Admin.NAME
        flash[:alert] = "You are not authorised to view an Admin's page"
        redirect_to :controller => 'dashboard', :action => 'view'
      end
    end
end
