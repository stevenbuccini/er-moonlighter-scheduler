require 'spec_helper'
require 'rails_helper'

RSpec.describe User, type: :model do
	describe 'Registration_complete' do
	  it 'should return true with fully registered user' do
	    user = FactoryGirl.create(:user)
	    expect(user.registration_complete).to eql true
	  end
	  it 'should return false with unregistered user' do
	    user = FactoryGirl.create(:user, email: 'test@example.com', password: 11111111, first_name: nil, last_name:nil)
	    expect(user.registration_complete).to eql false
	  end
	end

		describe 'Registration_complete' do
	  it 'should return the first and last name if both exist' do
	    user = User.create({first_name: 'Steph', last_name: 'Curry'})
			expect(user.full_name).to eql "Steph Curry"
	  end
	  it 'should indicate if a full name doesnt exist' do
	    user = User.create({first_name: 'Steph'})
			expect(user.full_name).to eql "User does not have a full name"
	  end
	end

	describe 'is_admin? method' do
		it 'should return true to if user is admin' do
      admin = Admin.create({first_name: 'Steph', last_name: 'Curry'})   
      expect(admin.is_admin?).to eql true
    end
    it 'should return false to if user is not an admin' do
      admin = User.create({first_name: 'Steph', last_name: 'Curry'})   
      expect(admin.is_admin?).to eql false
    end
	end
end
