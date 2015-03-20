require 'spec_helper'
require 'rails_helper'
require 'support/controller_macros'

RSpec.describe DoctorsController, type: :controller do
  #before do
  #   avoids problems with this method being protected
  #  ApplicationController.send(:public, *DoctorsController.protected_instance_methods)
  #end

  describe 'update a doctor' do
    login_admin
    before :each do
      @doctor = FactoryGirl.create(:doctor, :first_name => "Jennifer", :last_name => "Lopez", :phone_1 => '222-222-2222')
      #doctor_params = ActionController::Parameters.new(:first_name => "Suzie", :last_name => "Lopez", :phone_1 => '222-222-2222')
      #doctor_params = {:first_name => "Sara", :last_name => "Lopez", :phone_1 => '111-111-1111'}
      @id = Doctor.find_by_first_name("Jennifer")
    end

    #it 'should redirect to the doctor page' do
    #  doctor_params
    #  put :update, {:id => @id, :doctor => @doctor}
    #  @doctor.reload
    #  expect(response).to redirect_to(@doctor)
    #end
    #it 'should render the confirmation page' do

    #end
    #it 'should make the newly updated information available'
  end
end