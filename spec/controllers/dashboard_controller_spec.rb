require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #view" do
    login_user
    it "should returns http success" do
      get :view
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    login_admin
    it "should returns http success" do
      user = User.where(:email => "master@example.com")
      get :index, :id => user
      expect(response).to redirect_to admins_path
    end
  end



end
