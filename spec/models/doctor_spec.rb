require 'spec_helper'
require 'rails_helper'

RSpec.describe Doctor, type: :model do

  describe '#is_delinquent?' do
    it 'should return false if a doctor has worked a shift in the past MAX_TIME_SINCE_LAST_SHIFT' do
      stub_const("Doctor::MAX_TIME_SINCE_LAST_SHIFT", 3)
      expect(Doctor::MAX_TIME_SINCE_LAST_SHIFT).to eql 3
      a = FactoryGirl.create(:doctor, last_shift_completion_date: 2.months.ago.to_date)
      expect(a.is_delinquent?).to eql(false)
    end

    it 'should return true if a doctor has worked a shift in the past MAX_TIME_SINCE_LAST_SHIFT' do
      stub_const("Doctor::MAX_TIME_SINCE_LAST_SHIFT", 3)
      expect(Doctor::MAX_TIME_SINCE_LAST_SHIFT).to eql 3
      a = FactoryGirl.create(:doctor, last_shift_completion_date: 4.months.ago.to_date)
      expect(a.is_delinquent?).to eql(true)
    end
  end
end