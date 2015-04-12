
require 'spec_helper'
require 'rails_helper'
require 'support/controller_macros'

RSpec.describe ShiftsController, type: :controller do

  describe 'signing up for shifts' do

    it 'should successfully receive a list of Shift IDs as params.' do
      factory_doctor = FactoryGirl.create(:doctor)
      sign_in factory_doctor
      a = FactoryGirl.create(:shift)
      b = FactoryGirl.create(:shift)
      c = FactoryGirl.create(:shift)
      ids = [a.id, b.id, c.id]
      str_ids = [a.id.to_s, b.id.to_s, c.id.to_s]
      allow(controller).to receive(:current_user).and_return(factory_doctor)
      expect(Shift).to receive(:assign_multiple_shifts).with(str_ids, factory_doctor).and_return({})
      post :update, post: {shifts: ids}
    end
  end
end