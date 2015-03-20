require 'spec_helper'
require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  before do
     avoids problems with this method being protected
    ApplicationController.send(:public, *AdminsController.protected_instance_methods)
  end

  describe 'update an admin' do
    before :each do
      admin = FactoryGirl.create(:admin, :first_name => "Jennifer", :last_name => "Lopez", :phone_1 => '222-222-2222')
      admin_params = {:first_name => "Sara", :last_name => "Lopez", :phone_1 => '111-111-1111'}
    end
    it 'should call update in the model' do
      Admin.should_receive(:update).with(:first_name => "Sara")
      post :update, {:id => 1, :first_name => "Sara", :last_name => "Lopez", :phone_1 => '111-111-1111'}
    end
    it 'should render the confirmation page' do

    end
    it 'should make the newly updated information available'
  end
end