require 'spec_helper'
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
    before do
      # avoids problems with this method being protected
      ApplicationController.send(:public, *ApplicationController.protected_instance_methods)
    end

  describe "#admin_only_view" do
    it "redirects to the root if current_user returns a User model" do
      # Ensure that current user is a User model
      expect(controller).to receive(:current_user).and_return(User.new())
      # Stubbing redirect_to because we actually haven't rendered a page yet and I ran into weird errors
      # returning non-boolean value to distinguish it from the return type of redirect_to
      allow(controller).to receive_messages(:redirect_to => "garbage")
      response = controller.send(:admin_only_view)
      expect(response).to eql(false)
    end
    it "redirects to the root if current_user returns a Doctor model" do
      # Ensure that current user is a Doctor model
      expect(controller).to receive(:current_user).and_return(Doctor.new())
      # Stubbing redirect_to because we actually haven't rendered a page yet and I ran into weird errors
      # returning non-boolean value to distinguish it from the return type of redirect_to
      allow(controller).to receive_messages(:redirect_to => "garbage")
      response = controller.send(:admin_only_view)
      expect(response).to eql(false)
    end
    
    it "does not redirect if current_user returns an Admin model" do
      # Ensure that current user is a Admin model
      expect(controller).to receive(:current_user).and_return(Admin.new())
      # Stubbing redirect_to because we actually haven't rendered a page yet and I ran into weird errors
      allow(controller).to receive_messages(:redirect_to => "It Works")
      response = controller.send(:admin_only_view)
      expect(response).to eql(true)
    end
  end

  describe "#doctor_or_admin_view" do
    it "redirects to the root if current_user returns a User model" do
      # Ensure that current user is a User model
      expect(controller).to receive(:current_user).at_least(:once).and_return(User.new())
      # Stubbing redirect_to because we actually haven't rendered a page yet and I ran into weird errors
      allow(controller).to receive_messages(:redirect_to => "It Works")
      response = controller.send(:doctor_or_admin_view)
      expect(response).to eql(false)
    end
    it "does not redirect if current_user returns a Doctor model" do
      # Ensure that current user is a Doctor model
      expect(controller).to receive(:current_user).at_least(:once).and_return(Doctor.new())
      # Stubbing redirect_to because we actually haven't rendered a page yet and I ran into weird errors
      allow(controller).to receive_messages(:redirect_to => "It Works")
      response = controller.send(:doctor_or_admin_view)
      expect(response).to eql(true)
    end
    
    it "does not redirect if current_user returns an Admin model" do
      # Ensure that current user is a Admin model
      expect(controller).to receive(:current_user).at_least(:once).and_return(Admin.new())
      # Stubbing redirect_to because we actually haven't rendered a page yet and I ran into weird errors
      allow(controller).to receive_messages(:redirect_to => "It Works")
      response = controller.send(:doctor_or_admin_view)
      expect(response).to eql(true)
    end
  end

  describe '#after_sign_in_path' do 
    context 'fully registered user' do 
      before :each do 
        @request.env["devise.mapping"] = Devise.mappings[:doctor]
        user = FactoryGirl.create(:doctor)
        sign_in user
      end
      it 'should call registration_complete and return true' do 
        expect(User).to receive(:registration_complete).and_return(true)
        get :after_sign_in_path, {:user => user}
      end

      it 'should render doctor index' do 
        User.stub(:registration_complete).and_return(@user)
        get :after_sign_in_path, {:user => user}
        expect(response).to render_template('doctors')
      end
    end

    context 'unregistered user' do 
      before :each do 
        @request.env["devise.mapping"] = Devise.mappings[:doctor]
        user = FactoryGirl.create(:doctor, first_name: nil)
        sign_in user
      end
      it 'should call registration_complete and return false' do 
        expect(User).to receive(:registration_complete).and_return(false)
        get :after_sign_in_path, {:user => user}
      end
      it 'should render the edit user page' do 
        User.stub(:registration_complete).and_return(false)
        get :after_sign_in_path, {:user => user}
        expect(response).to render_template('users/edit')
      end
    end
  end



end

















