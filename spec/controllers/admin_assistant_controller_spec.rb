require 'rails_helper'

RSpec.describe AdminAssistantController, type: :controller do
	describe 'set_admin method' do 
    login_admin
    before :each do 
      @admin = FactoryGirl.create(:admin_assistant)
    end
    it 'should call .all on each model' do 
      expect(AdminAssistant).to receive(:find).and_return(@admin)
      get :edit, :id => @admin.id
    end
  end

end
