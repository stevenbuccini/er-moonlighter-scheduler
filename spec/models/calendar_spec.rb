require 'spec_helper'
require 'rails_helper'
require 'google/api_client'
# require 'app/models/concerns/calendar' #ERROR

RSpec.describe Calendar, type: :model do

	#include Calendar
	#include Shift #ERROR because it's not a module, it's a class


	#@calendar = Calendar.new(:client_id => @client_id, :client_secret => @client_secret, :redirect_url => "urn:ietf:wg:oauth:2.0:oob", :refresh_token => @refresh_token, :calendar => @calendar_id)

	describe 'creating an event' do

		#include Calendar
		#include Shift

		it 'should make a successful request to Google Calendar' do

			shift = Shift.create({start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 2, 15, 8, 00)})
			doctor = Doctor.create({first_name: 'KRISTINA', last_name: 'Doctor'})
			shift.doctor = doctor
			shift.save!

			Calendar.gcal_event_insert(shift)
			Calendar.init_calendar

			status = Calendar.gcal_get_events_in_range(shift.start_datetime, shift.end_datetime).status
			expect(status).to eql 200
		end


		it 'should successfully create and insert events into the Google Calendar' do
			shift = Shift.create({start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 2, 15, 8, 00)})
			doctor = Doctor.create({first_name: 'CHRIS', last_name: 'Doctor'})
			shift.doctor = doctor
			shift.save!

			Calendar.gcal_event_insert(shift)
			Calendar.init_calendar

			#checks if request was successful
			success = Calendar.gcal_get_events_in_range(shift.start_datetime, shift.end_datetime).success?
			expect(success).to eql true
		end


		it 'should create and insert events into the Google Calendar that have a doctor tied to it' do

			shift = FactoryGirl.create(:shift, {confirmed: true})
			doctor = FactoryGirl.create(:doctor, :first_name => "AUDREY", :last_name => "HEPBURN", :phone_1 => '111-222-2222')

			#shift = Shift.create({start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 2, 15, 8, 00)})
			#doctor = Doctor.create({first_name: 'MEGHANA', last_name: 'Doctor'})
			shift.doctor = doctor
			shift.save!

			Calendar.gcal_event_insert(shift)
			Calendar.init_calendar

			#expect(Calendar).to receive(:gcal_event_insert).at_least(:once)
		end

		it 'should insert an event to the correct calendar' do

			first_shift = FactoryGirl.create(:shift, {confirmed: true})
			doctor = FactoryGirl.create(:doctor, :first_name => "JEN", :last_name => "LOPEZ", :phone_1 => '222-222-2222')
			first_shift.doctor = doctor
			first_shift.save

			Calendar.gcal_event_insert(first_shift)

			# doctor2 = FactoryGirl.create(:doctor, :first_name => "AUDREY", :last_name => "HEPBURN", :phone_1 => '111-111-1111')
			# first_shift.doctor = doctor2
			# first_shift.save
			# Calendar.gcal_event_update(first_shift)

			#Calendar.init_calendar

			data_string = Calendar.gcal_get_events_in_range(first_shift.start_datetime, first_shift.end_datetime).data.to_yaml
			summary = data_string.split(' ')[8].strip
			expect(summary).to eql "ermoonlighter@gmail.com"
		end


=begin


		#WHY ISNT THIS TEST WORKING GAAAHHH
		it 'should delete events in the Google Calendar' do

			#shift = Shift.create({start_datetime: DateTime.new(2015, 5, 14, 8, 00), end_datetime: DateTime.new(2015, 5, 15, 8, 00)})
			#doctor = Doctor.create({first_name: 'KRISTINA', last_name: 'Doctor'})

			shift = FactoryGirl.create(:shift, {confirmed: true})
			doctor = FactoryGirl.create(:doctor, :first_name => "MEGHANA", :last_name => "BESTDOCTOREVER", :phone_1 => '123-123-2222')

			puts "THIS IS THE SHIFT:" , shift

			shift.doctor = doctor
			shift.save!

			Calendar.gcal_event_insert(shift)

			#start_datetime = DateTime.new(2015, 5, 14, 8, 00)
			#end_datetime = DateTime.new(2015, 5, 15, 8, 00)
			#event_to_delete = Calendar.gcal_get_events_in_range(start_datetime, end_datetime)

			#puts "THIS IS THE EVENT BEING DELETED: ",  event_to_delete




			Calendar.gcal_event_delete(shift)
			Calendar.init_calendar

			#present = Calendar.gcal_get_events_in_range(shift.start_datetime, shift.end_datetime).present?
			#puts "THIS IS THE PRESENT: ", present


			#puts "TEST OUT VARIOUS METHODS HERE: "
			#puts Calendar.gcal_get_events_in_range(shift.start_datetime, shift.end_datetime).headers

			#expect(present).to eql false
			#------------------------------------------------------------------------------------------------
		end





		it 'should update an event with a given shift object input with the proper parameters' do

			#first_shift = Shift.create({start_datetime: DateTime.new(2015, 2, 15, 8, 00), end_datetime: DateTime.new(2015, 2, 16, 8, 00)})
			first_shift = FactoryGirl.create(:shift, {confirmed: true})
			#shifts_hash = Shift.create_shifts_for_pay_period(DateTime.now, DateTime.now.advance(days: 3), 1)
			#puts shifts_hash
			#ERROR: THIS IS EMPTY

			#first_shift = shifts_hash.first

			#doctor = Doctor.create({first_name: 'GREEN', last_name: 'BLUE'})
			doctor = FactoryGirl.create(:doctor, :first_name => "JEN", :last_name => "LOPEZ", :phone_1 => '222-222-2222')


			#puts "THIS IS DOCTOR 1: ", doctor
			#puts "THIS IS DOCTOR 2: ", doctor2

			first_shift.doctor = doctor
			first_shift.save!

			#Calendar.convert_to_gcal_event(shift)

			Calendar.gcal_event_insert(first_shift)
			#puts Calendar.client #THIS DOES NOT WORK
			#puts shift.to_s #THIS WORKS

			#Calendar.gcal_event_update(first_shift)

			#Calendar.gcal_event_delete(shift)

			Calendar.init_calendar
			#puts "HERES THE DATA: ", Calendar.gcal_get_events_in_range(first_shift.start_datetime, first_shift.end_datetime).data.to_yaml
			data_string = Calendar.gcal_get_events_in_range(first_shift.start_datetime, first_shift.end_datetime).data.to_yaml
			summary = data_string.split(' ')#[15].strip
			puts "SUMMARY: ", summary[8]

			expect(summary[8]).to eql "ermoonlighter@gmail.com"

			#expect(Calendar).to receive(:gcal_event_update).at_least(:once)

			#puts "\n\n\nTHIS IS THE EVENT: \n" + Calendar.gcal_get_events_in_range(shift.start_datetime, shift.end_datetime).body
			#File.stub(:exists?).and_return(false)
			#File.stub(:exists?).and_return(true)

		end

=end


	end
end
