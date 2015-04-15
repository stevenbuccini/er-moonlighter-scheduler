require "rails_helper"

RSpec.describe PayPeriodsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pay_periods").to route_to("pay_periods#index")
    end

    it "routes to #new" do
      expect(:get => "/pay_periods/new").to route_to("pay_periods#new")
    end

    it "routes to #show" do
      expect(:get => "/pay_periods/1").to route_to("pay_periods#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pay_periods/1/edit").to route_to("pay_periods#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pay_periods").to route_to("pay_periods#create")
    end

    it "routes to #update" do
      expect(:put => "/pay_periods/1").to route_to("pay_periods#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pay_periods/1").to route_to("pay_periods#destroy", :id => "1")
    end

  end
end
