require 'spec_helper'
require 'rails_helper'

RSpec.describe AdminsController, type: :controller do

  describe 'update an admin' do
    login_admin
    before :each do
      @admin = FactoryGirl.build(:admin, :first_name => "Jennifer", :last_name => "Lopez", :phone_1 => '222-222-2222')
      @admin.save!
      @new_first_name = "Sara"
      Admin.stub(:find).and_return(@admin)
    end

    it 'should call the update Model method' do
      @admin.should_receive(:update).with({"first_name" => @new_first_name}.with_indifferent_access)#.and_return(:true)
      put :update, :id => @admin.id, :admin => {:first_name => @new_first_name}
    end

    it 'should correctly update the admin' do
      put :update, :id => @admin.id, :admin => {:first_name => @new_first_name}
      expect(@admin.first_name).to eql @new_first_name
    end

    it 'should redirect to the admin page' do
      put :update, :id => @admin.id, :admin => {:first_name => @new_first_name}
      expect(response).to redirect_to @admin
    end 
  end

  describe 'sending an email' do
    login_admin
    before :each do
      @admin = FactoryGirl.build(:admin, :first_name => "Jennifer", :last_name => "Lopez", :phone_1 => '222-222-2222')
      @admin.save!
      @new_first_name = "Sara"
      Admin.stub(:find).and_return(@admin)
    end

    it "renders the create_email template" do
      get :create_email
      expect(response).to render_template("create_email")
    end

    it "post send_mail redirects to root" do
      post :send_email
      expect(response).to redirect_to root_url
    end

  end
end