require 'rails_helper'

RSpec.describe "pay_periods/index", type: :view do
  before(:each) do
    assign(:pay_periods, [
      FactoryGirl.create(:pay_period),
      FactoryGirl.create(:pay_period)
    ])
  end

  it "renders a list of pay_periods" do
    render
  end
end
