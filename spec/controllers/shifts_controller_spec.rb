# Test the update method
# Make sure that it handles failures correctly by stubbing out the save method
# Yeah that's it but it's gonna be harder than you think

require 'spec_helper'
require 'rails_helper'
require 'support/controller_macros'

RSpec.describe ShiftsController, type: :controller do

  describe 'signing up for shifts' do

    it 'should successfully receive a list of Shift IDs as params.' do
      factory_doctor = FactoryGirl.create(:doctor)
      sign_in factory_doctor
      allow(controller).to receive(:current_user).and_return(factory_doctor)
      expect(Shift).to receive(:assign_multiple_shifts).with(["1", "2", "3"], factory_doctor).and_return({})
      post :update, post: {shifts: [1,2,3]}
    end
  end
end