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
			shift = Shift.create({start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 3, 15, 8, 00)})
			doctor = Doctor.create({first_name: 'Donald', last_name: 'Doctor'})

			shift.doctor = doctor
			shift.save!

			Calendar.convert_to_gcal_event(shift)

			Calendar.gcal_event_insert(shift)
			#puts Calendar.client #THIS DOES NOT WORK
			#puts shift.to_s #THIS WORKS

			#Calendar.gcal_event_update(shift)

			#Calendar.gcal_event_delete(shift)
			#File.stub(:exists?).and_return(false)
			#File.stub(:exists?).and_return(true)

			Calendar.init_calendar

			puts Calendar.gcal_get_events_in_range(shift.start_datetime, shift.end_datetime).body

		end

	end

end
