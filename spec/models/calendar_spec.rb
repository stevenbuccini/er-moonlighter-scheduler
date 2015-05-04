require 'spec_helper'
require 'rails_helper'
require 'google/api_client'
# require 'app/models/concerns/calendar' #ERROR

RSpec.describe Calendar, type: :model do

	#include Calendar
	#include Shift #ERROR because it's not a module, it's a class


	#@calendar = Calendar.new(:client_id => @client_id, :client_secret => @client_secret, :redirect_url => "urn:ietf:wg:oauth:2.0:oob", :refresh_token => @refresh_token, :calendar => @calendar_id)

	describe 'updating an event' do

		#include Calendar
		#include Shift


		it 'should update an event with a given shift object input with the proper parameters' do

			#shift = Shift.create({start_datetime: DateTime.new(2015, 2, 15, 8, 00), end_datetime: DateTime.new(2015, 2, 16, 8, 00)})
			shift = Shift.create_shifts_for_pay_period(DateTime.now, DateTime.now.advance(days: 3), 1)

			#doctor = Doctor.create({first_name: 'GREEN', last_name: 'BLUE'})
			doctor = FactoryGirl.create(:doctor, :first_name => "JEN", :last_name => "LOPEZ", :phone_1 => '222-222-2222')

			puts "THIS IS THE DOCTOR", doctor
			shift.doctor = doctor
			shift.save!

			#Calendar.convert_to_gcal_event(shift)

			#Calendar.gcal_event_insert(shift)
			#puts Calendar.client #THIS DOES NOT WORK
			#puts shift.to_s #THIS WORKS

			Calendar.gcal_event_update(shift)

			#Calendar.gcal_event_delete(shift)



			Calendar.init_calendar

			puts "\n\n\nTHIS IS THE EVENT: \n" + Calendar.gcal_get_events_in_range(shift.start_datetime, shift.end_datetime).body
			#File.stub(:exists?).and_return(false)
			#File.stub(:exists?).and_return(true)

		end

	end

end
