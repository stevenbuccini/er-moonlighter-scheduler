require 'spec_helper'
 
RSpec.describe AdminsController do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
   
  end
  
  describe "send_mass_email function" do
    it 'should send an email' do
       doctor = double("doc", :email => "me@example.com", :first_name => "paul")
      UserMailer.custom_email(doctor, "foo", "bar").deliver_now
      ActionMailer::Base.deliveries.count.should == 1
    end
    it 'should not send an email if the doctor being mailed has no address' do
       doctor = double("doc", :email => nil, :first_name => "paul")
    UserMailer.custom_email(doctor, "foo", "bar").deliver_now
      ActionMailer::Base.deliveries.count.should == 0
    end
  end

  describe "send_mass_email function" do
    it 'should send an email' do
       doctor = double("doc", :email => "me@example.com", :name => "Paul Green")
      UserMailer.welcome_email(doctor).deliver_now
      ActionMailer::Base.deliveries.count.should == 1
    end
    it 'should not send an email if the doctor being mailed has no address' do
       doctor = double("doc", :email => nil)
    UserMailer.welcome_email(doctor).deliver_now
      ActionMailer::Base.deliveries.count.should == 0
    end
  end

end