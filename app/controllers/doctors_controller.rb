class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! 
  before_filter :check_users_authorization, :except => [:destroy, :show, :edit, :update]# Redirects if user isn't signed in

  # GET /doctors
  # GET /doctors.json
  def index
    @doctors = Doctor.all
    @shifts = Shift.where(confirmed: false)
    # @shifts_phase_one = Shift.where(is_open: true)
  end

  def contact_list
    @doctors = Doctor.all
    @admins = Admin.all 
  end

  # def shift_phase_one
  #   @shifts = Shift.where(is_open: true)
  # end


  # GET /doctors/1
  # GET /doctors/1.json
  def show
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  # GET /doctors/1/edit
  def edit
  end

  # POST /doctors
  # POST /doctors.json
  # def create
  #   @doctor = Doctor.new(doctor_params)

  #   respond_to do |format|
  #     if @doctor.save
  #       format.html { redirect_to @doctor, notice: 'Doctor was successfully created.' }
  #       format.json { render :show, status: :created, location: @doctor }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @doctor.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /doctors/1
  # PATCH/PUT /doctors/1.json
  def update
    #@doctor = Doctor.find(params[:id])
    set_doctor
    update_helper(@doctor, "Doctor", doctor_params)
  end

  # DELETE /doctors/1
  # DELETE /doctors/1.json
  def destroy
    destroy_helper(@doctor, :back, "Doctor")
  end

  def sign_up_for_shift

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doctor_params
      params.require(:doctor).permit(:first_name, :last_name, :phone_1, :phone_2, :phone_3, :comments)
    end

    def check_users_authorization
      check_users_authorization_helper(Doctor.NAME)
    end
end
