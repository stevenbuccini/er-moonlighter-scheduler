require 'spec_helper'
require 'rails_helper'

RSpec.describe Admin, type: :model do

  describe 'Admin' do
    
    it 'should have a get_doctor_names method' do
      admin = Admin.create({first_name: 'Steph', last_name: 'Curry'})
      doctors = [Doctor.create({first_name: 'Donald', last_name: 'Doctor'}), Doctor.create({first_name: 'Goofy', last_name: 'Goof'})]
      expect(Admin.get_doctor_names(doctors)).to eql "Donald Doctor and Goofy Goof"
    end

    it 'should call send email correctly with urgent option.' do
     admin = Admin.create({first_name: 'Steph', last_name: 'Curry'})
     doctor = Doctor.create({first_name: 'Donald', last_name: 'Doctor', email:"foo@example.com"})
     expect(admin.send_email(doctor,{email_type: "urgent"})).to eql nil
    end

    it 'should call send email correctly with new pay period option.' do
     admin = Admin.create({first_name: 'Steph', last_name: 'Curry'})
     doctor = Doctor.create({first_name: 'Donald', last_name: 'Doctor', email:"foo@example.com"})
     expect(admin.send_email(doctor,{email_type: "new_pay_period"})).to eql nil
    end

    it 'should call send email correctly with custom option' do
     admin = Admin.create({first_name: 'Steph', last_name: 'Curry'})
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
      admin = FactoryGirl.create(:admin)
      expect(admin.last_shift_completion_date).to eql nil
    end
  end
end