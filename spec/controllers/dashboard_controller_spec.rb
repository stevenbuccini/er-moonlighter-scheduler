require 'spec_helper'
require 'rails_helper'
require 'support/controller_macros'
RSpec.describe DashboardController, type: :controller do

  describe "GET #view" do
    login_user
    it "should returns http success" do
      get :view
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET#index' do 
    # subject { get :index }
    # specify { should render_template('/dashboard/index') }
    # specify { should render_template("layouts/application") }
    #login_user
    before :each do 
      @doctor = FactoryGirl.create(:doctor)
      @admin = FactoryGirl.create(:admin)
      @user = FactoryGirl.create(:user)
    end
    it 'should redirect to /admins for admin' do 
      sign_in @admin
      get :index
      expect(response).to redirect_to admins_path
    end
    it 'should redirect doctor to /doctors' do 
      sign_in @doctor
      get :index
      expect(response).to redirect_to doctors_path
    end
  
  end
end
