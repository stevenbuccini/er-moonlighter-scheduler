require 'rails_helper'

RSpec.describe "pay_periods/new", type: :view do
  before(:each) do
    assign(:pay_period, PayPeriod.new())
  end

  it "renders new pay_period form" do
    render

    #assert_select "form[action=?][method=?]", pay_periods_path, "post" do
    #end
  end
end
