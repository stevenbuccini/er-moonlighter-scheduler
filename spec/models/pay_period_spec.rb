require 'rails_helper'

RSpec.describe PayPeriod, type: :model do
  describe 'creating a pay_period' do
         
    it 'should not create a PayPeriod if missing a start or end date.' do
      pay_period = PayPeriod.create({end_date: DateTime.new(2015, 3, 15, 8, 00)})
      expect(pay_period.errors[:start_date]).to include("can't be blank")
      expect(pay_period.errors[:end_date]).to eql []

      pay_period = PayPeriod.create({start_date: DateTime.new(2015, 3, 15, 8, 00)})
      expect(pay_period.errors[:end_date]).to include("can't be blank")
      expect(pay_period.errors[:start_date]).to eql []

      pay_period = PayPeriod.create()
      expect(pay_period.errors[:start_date]).to include("can't be blank")
      expect(pay_period.errors[:end_date]).to include("can't be blank")
    end

    it 'should not create a pay_period if the start time comes after an end time.' do
      pay_period = PayPeriod.create({start_date: DateTime.new(2015, 3, 15, 8, 00), end_date: DateTime.new(2015, 2, 14, 8, 00)})
      expect(pay_period.errors[:base]).to include("End date cannot be less than start date")
    end
  end
end
