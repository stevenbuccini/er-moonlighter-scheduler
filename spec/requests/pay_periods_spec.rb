require 'rails_helper'
require 'spec_helper'

RSpec.describe "PayPeriods", type: :request do
  describe "GET /pay_periods" do
  	#login_admin
    it "works! (now write some real specs)" do
      get pay_periods_path
      #expect(response).to be_success
    end
  end
end
