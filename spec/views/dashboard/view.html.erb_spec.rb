require 'rails_helper'

RSpec.describe "dashboard/view.html.erb", type: :view do
	it "should display page" do
	  render
		rendered.should have_selector("h1")
	end
end
