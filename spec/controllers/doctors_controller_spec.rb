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
      expect(Doctor).to receive(:find).at_least(:once).and_return(@doctor)
    end

    it 'should call the update Model method' do
      
      expect(@doctor).to receive(:update).with({"first_name" => @new_first_name}.with_indifferent_access)
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

   describe 'edit' do 
    login_admin
    before :each do 
      @doctor = FactoryGirl.create(:doctor)
    end
    it 'should call .find in Doctor' do 
      expect(Doctor).to receive(:find).at_least(:once).with(@doctor.id.to_s).and_return(@doctor)
      get :edit, :id => @doctor.id
    end
    it 'should render the show page' do 
      expect(Doctor).to receive(:find).at_least(:once).and_return(@doctor)
      get :edit, :id => @doctor.id
      expect(response).to render_template('doctors/edit/')
    end
  end

  describe '#check_users_authorization' do 
    controller do 
      before_filter :check_users_authorization
    end
    context 'user with type nil' do 
      before :each do 
        @user = FactoryGirl.create(:user, type: nil)
        sign_in @user
      end
      it 'should redirect nil user to dashboard' do 
        get :index
        expect(flash[:alert]).to be_present
      end
      it 'should redirect nil user to dashboard' do 
        get :index
        expect(response).to redirect_to('/dashboard/view')
      end
    end

    context 'valid user' do 
      before :each do 
        @doctor = FactoryGirl.create(:doctor)
        sign_in @doctor
      end
      it 'should render the correct template' do 
        get :index
        expect(response).to render_template('doctors/index')
      end
    end
  end
end