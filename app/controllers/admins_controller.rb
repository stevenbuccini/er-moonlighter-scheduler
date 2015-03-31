class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! # redirect if user isn't signed in
  before_filter :admin_only_view, only: [:create_new_email, :send_mass_email]

  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all
    @doctors = Doctor.all
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
    subject = params[:subject]
    text = params[:body]
    @doctors.each do |doctor|
      UserMailer.dummy_email(doctor, subject, text).deliver_now
      if doctor.first_name != nil and doctor.last_name != nil
        sent_to = sent_to + " " + doctor.first_name + " " + doctor.last_name
      end
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
      if @admin.update!(admin_params)
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
end
