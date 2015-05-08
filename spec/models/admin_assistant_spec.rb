require 'rails_helper'

RSpec.describe AdminAssistant, type: :model do
  describe 'Admin assistant' do
    
    it 'should call send email correctly with urgent option.' do
     admin = AdminAssistant.create({first_name: 'Steph', last_name: 'Curry'})
     doctor = Doctor.create({first_name: 'Donald', last_name: 'Doctor', email:"foo@example.com"})
     expect(admin.send_email(doctor,{email_type: "urgent"})).to eql nil
    end

    it 'should call send email correctly with new pay period option.' do
     admin = AdminAssistant.create({first_name: 'Steph', last_name: 'Curry'})
     doctor = Doctor.create({first_name: 'Donald', last_name: 'Doctor', email:"foo@example.com"})
     expect(admin.send_email(doctor,{email_type: "new_pay_period"})).to eql nil
    end

    it 'should call send email correctly with custom option' do
     admin = AdminAssistant.create({first_name: 'Steph', last_name: 'Curry'})
     doctor = Doctor.create({first_name: 'Donald', last_name: 'Doctor', email:"foo@example.com"})
     expect(admin.send_email(doctor,{email_type: "custom", subject: "foo", body: "bar"})).to eql nil
    end
  end

  describe 'last_shift_completion_date field' do
    it 'should not be writeable' do
      admin = FactoryGirl.create(:admin)
      expect {admin.last_shift_completion_date = Date.parse('Fri, 26 Jun 2015')}.to raise_error
    end

    it 'should be readable, but return nil even if a date is set.' do
      admin = FactoryGirl.create(:admin_assistant)
      expect(admin.last_shift_completion_date).to eql nil
    end
  end
end
