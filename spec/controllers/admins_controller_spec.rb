require 'spec_helper'
require 'rails_helper'

RSpec.describe AdminsController, type: :controller do

  describe 'update an admin' do
    login_admin
    before :each do
      @admin = FactoryGirl.create(:doctor, :first_name => "Jennifer", :last_name => "Lopez", :phone_1 => '222-222-2222')
      #doctor_params = ActionController::Parameters.new(:first_name => "Suzie", :last_name => "Lopez", :phone_1 => '222-222-2222')
      #doctor_params = {:first_name => "Sara", :last_name => "Lopez", :phone_1 => '111-111-1111'}
      @id = Admin.find_by_first_name("Jennifer")
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