class PayPeriodsController < ApplicationController
  before_filter :authenticate_user! # redirect if user isn't signed in
  before_filter :check_user_authorization, :except => :destroy# redirect if user is not an admin
  before_action :set_pay_period, only: [:show, :edit, :update, :destroy]


  # GET /pay_periods
  # GET /pay_periods.json
  def index
    @pay_periods = PayPeriod.all
  end

  # GET /pay_periods/1
  # GET /pay_periods/1.json
  def show
  end

  # GET /pay_periods/new
  def new
    @pay_period = PayPeriod.new
  end

  # GET /pay_periods/1/edit
  def edit
    @payperiod = PayPeriod.find_by_id params[:id]
  end

  # POST /pay_periods
  # POST /pay_periods.json
  def create
    @pay_period = PayPeriod.new(pay_period_params)

    respond_to do |format|
      if @pay_period.save
        format.html { redirect_to @pay_period, notice: 'Pay period was successfully created.' }
        format.json { render :show, status: :created, location: @pay_period }

        #Changing the payperiod id for all admin and doctor
        Admin.update_pay_period(params[:new_pay_period])
        Doctor.update_pay_period(params[:new_pay_period])
        params[:new_pay_period] = @pay_period.id
      else
        format.html { render :new }
        format.json { render json: @pay_period.errors, status: :unprocessable_entity }
      end
      #redirect_to :controller => 'admin', :action => 'update_doctor_and_admin_pay_period', :id => @pay_period.id and return
    end
  end

  # PATCH/PUT /pay_periods/1
  # PATCH/PUT /pay_periods/1.json
  def update
    respond_to do |format|
      if @pay_period.update(pay_period_params)
        format.html { redirect_to @pay_period, notice: 'Pay period was successfully updated.' }
        format.json { render :show, status: :ok, location: @pay_period }
      else
        format.html { render :edit }
        format.json { render json: @pay_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_periods/1
  # DELETE /pay_periods/1.json
  def destroy
    @pay_period.destroy
    respond_to do |format|
      format.html { redirect_to pay_periods_url, notice: 'Pay period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_period
      @pay_period = PayPeriod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pay_period_params
      params.require(:pay_period).permit(:start_date, :end_date)
    end

    def check_user_authorization
      if current_user.type != Admin.NAME
        flash[:alert] = "You are not authorised to perform this action"
        redirect_to :controller => 'dashboard', :action => 'view'
      end
    end
end
