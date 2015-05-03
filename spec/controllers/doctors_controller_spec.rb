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

  describe 'doctor index' do
    before :each do 
      @doctor = FactoryGirl.create(:doctor)
      sign_in @doctor
    end
    it 'should set @claimed_shifts if there is data in the session' do 
      shift = FactoryGirl.create(:shift)
      get :index, nil, {claimed_shifts: [shift]} # Params hash is empty, but set session hash.
      expect(session[:claimed_shifts]).to eql nil
      expect(assigns(:claimed_shifts)).to eq([shift])
    end
  end

  describe 'contact list' do
    before :each do 
      @doctor = FactoryGirl.create(:doctor)
      sign_in @doctor
    end

    it 'should correctly set the instance variables' do
      a = FactoryGirl.create(:doctor, {email: "a@xample.com"})
      b = FactoryGirl.create(:doctor, {email: "b@example.com"})
      x = FactoryGirl.create(:admin, {email: "x@example.com"})
      y = FactoryGirl.create(:admin, {email: "y@example.com"})
      controller.contact_list
      expect(assigns(:doctors).length).to eql 3
      expect(assigns(:admins).length).to eql 2
    end
  end

  describe 'doctor#new' do
    before :each do 
      @doctor = FactoryGirl.create(:doctor)
      sign_in @doctor
    end
    it 'should set @claimed_shifts if there is data in the session' do
      get :new
      assert_response :success
      expect(assigns(:doctor)).not_to eql nil
      expect(assigns(:doctor).new_record?).to eql true
    end
  end

  describe 'doctor#my_shifts' do
    before :each do 
      @doctor = FactoryGirl.create(:doctor)
      sign_in @doctor
    end
    it 'should correctly assign shifts' do
      FactoryGirl.create(:shift, {doctor: @doctor, confirmed: true})
      FactoryGirl.create(:shift, {doctor: @doctor, confirmed: true})
      FactoryGirl.create(:shift, {doctor: @doctor, confirmed: true})
      expect(Shift.all.count).to eql 3
      get :my_shifts
      expect(assigns(:confirmedShifts).length).to eql 3
    end
  end

end