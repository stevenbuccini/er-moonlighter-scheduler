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
      @new_first_name = "Sara"
      Doctor.stub(:find).and_return(@doctor)
    end

    it 'should call the update Model method' do
      
      @doctor.should_receive(:update!).with({"first_name" => @new_first_name}.with_indifferent_access)#.and_return(:true)
      put :update, :id => @doctor.id, :doctor => {:first_name => @new_first_name}
    end

    it 'should correctly update the doctor' do
      put :update, :id => @doctor.id, :doctor => {:first_name => @new_first_name}
      expect(@doctor.first_name).to eql @new_first_name
    end

    it 'should redirect to the doctor page' do
      put :update, :id => @doctor.id, :doctor => {:first_name => @new_first_name}
      expect(response).to redirect_to @doctor
    end 
  end
end