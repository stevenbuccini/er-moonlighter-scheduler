require 'rails_helper'

RSpec.describe "pay_periods/edit", type: :view do
  before(:each) do
    @pay_period = assign(:pay_period, FactoryGirl.create(:pay_period))
  end

  it "renders the edit pay_period form" do
    render

    #assert_select "form[action=?][method=?]", pay_periods_path, "post" do
   # end
  end
end
