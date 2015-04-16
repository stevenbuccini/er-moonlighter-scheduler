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

  describe 'index method' do 
    login_admin
    before :each do 
      @admin = FactoryGirl.create(:admin)
      @doctor = FactoryGirl.create(:doctor)
      @shift = FactoryGirl.create(:shift)
      @user1 = FactoryGirl.create(:user, type: nil)
      @user2 = FactoryGirl.create(:user, type: nil, email: "s@example.com")
    end
    it 'should call .all on each model' do 
      expect(Admin).to receive(:all).and_return(@admin)
      expect(Doctor).to receive(:all).and_return(@doctor)
      expect(Shift).to receive(:all).and_return(@shift)
      expect(User).to receive(:where).at_least(:once).with("nil").and_return(@user1, @user2)
      get :index
    end
  end

  describe 'show' do 
    login_admin
    before :each do 
      @admin = FactoryGirl.create(:admin)
    end
    it 'should call .find in Admin' do 
      expect(Admin).to receive(:find).at_least(:once).with(@admin.id.to_s).and_return(@admin)
      get :show, :id => @admin.id
    end
    it 'should render the show page' do 
      Admin.stub(:find).and_return(@admin)
      get :show, :id => @admin.id
      expect(response).to render_template('admins/show/')
    end
  end

  describe 'new' do 
    login_admin
    it 'should call new in Admin' do 
      expect(Admin).to receive(:new)
      get :new
    end
  end

  describe 'edit' do 
    login_admin
    before :each do 
      @admin = FactoryGirl.create(:admin)
    end
    it 'should call .find in Admin' do 
      expect(Admin).to receive(:find).at_least(:once).with(@admin.id.to_s).and_return(@admin)
      get :edit, :id => @admin.id
    end
    it 'should render the show page' do 
      Admin.stub(:find).and_return(@admin)
      get :edit, :id => @admin.id
      expect(response).to render_template('admins/edit/')
    end
  end
end

















