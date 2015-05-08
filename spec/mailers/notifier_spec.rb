require "rails_helper"

RSpec.describe Notifier, type: :mailer do
  describe 'instructions' do
    before :each do 
      @admin = FactoryGirl.create(:admin_assistant)
      @user = FactoryGirl.create(:doctor)
      @subject = "Swap"
      @text = "looking for shift Swap"
      @mail = Notifier.notify(@admin ,@user, @subject, @text)
      #expect(UserMailer).to receive(:custom_email).at_least(:once)
    end
 
    it 'renders the subject' do
      expect(UserMailer).to receive(:custom_email).at_least(:once)
      @admin.send_email(@user, {:subject => {'Subject' => ""},:body => {'Email Body'=> ""}})
    end
 
    # it 'renders the receiver email' do
    #   expect(@mail.to).to eql([@user.email])
    # end
 
    # it 'renders the sender email' do
    #   expect(@mail.from).to eql([' no-reply@moonlighter.com'])
    # end
  end
end
