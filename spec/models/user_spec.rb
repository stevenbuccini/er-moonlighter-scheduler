require 'spec_helper'
require 'rails_helper'

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