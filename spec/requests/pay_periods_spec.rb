require 'rails_helper'

RSpec.describe "PayPeriods", type: :request do
  describe "GET /pay_periods" do
    it "works! (now write some real specs)" do
      get pay_periods_path
      expect(response).to have_http_status(200)
    end
  end
end
