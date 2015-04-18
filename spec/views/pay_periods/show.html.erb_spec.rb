require 'rails_helper'

RSpec.describe "pay_periods/show", type: :view do
  before(:each) do
    @pay_period = assign(:pay_period, FactoryGirl.create(:pay_period))
  end

  it "renders attributes in <p>" do
    render
  end
end
