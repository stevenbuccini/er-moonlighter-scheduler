require 'spec_helper'
require 'rails_helper'

RSpec.describe Shift, type: :model do

  describe 'creating a shift' do
    
    it 'should set self.confirmed to false on create' do
      shift = Shift.create({start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 3, 15, 8, 00)})
      expect(shift.confirmed).to eql false
    end
      
    it 'should not create a shift if we are missing a start OR end time.' do
      shift = Shift.create({end_datetime: DateTime.new(2015, 3, 15, 8, 00)})
      expect(shift.errors[:start_datetime]).to include("can't be blank")
      expect(shift.errors[:end_datetime]).to eql []

      shift = Shift.create({start_datetime: DateTime.new(2015, 3, 15, 8, 00)})
      expect(shift.errors[:end_datetime]).to include("can't be blank")
      expect(shift.errors[:start_datetime]).to eql []

      shift = Shift.create()
      expect(shift.errors[:start_datetime]).to include("can't be blank")
      expect(shift.errors[:end_datetime]).to include("can't be blank")
    end

    it 'should not create a shift if the start time comes after an end time.' do
      shift = Shift.create({start_datetime: DateTime.new(2015, 3, 15, 8, 00), end_datetime: DateTime.new(2015, 2, 14, 8, 00)})
      expect(shift.errors[:sanity_check]).to include("end time can't be before the start time")
    end
  end

  describe 'pretty printing a shift' do
    it 'should pretty print a shift using to_s' do
      # create manually 
      shift = Shift.create({start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 3, 15, 13, 00)})
      expect(shift.to_s).to eql "Feb 14, 8:00 AM - Mar 15, 1:00 PM"
    end

    it 'should pretty print a shift using to_str' do
      shift = FactoryGirl.create(:shift, {start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 3, 15, 13, 00)})
      expect(shift.to_s).to eql "Feb 14, 8:00 AM - Mar 15, 1:00 PM"
    end
  end

  describe 'booking a shift' do
    it 'should confirm a shift for a given doctor.' do
      doc = FactoryGirl.create(:doctor)
      shift = FactoryGirl.create(:shift)
      shift.book(doc)
      expect(shift.confirmed).to eql true
      expect(shift.doctor).to eql doc
    end
  end

  describe 'booking multiple shifts at once' do
    it 'should confirm multiple shifts at once' do 
      a = FactoryGirl.create(:shift)
      b = FactoryGirl.create(:shift)
      c = FactoryGirl.create(:shift)
      expect(a.confirmed).to eql false
      expect(b.confirmed).to eql false
      expect(c.confirmed).to eql false
      expect(a.doctor).to eql nil
      expect(b.doctor).to eql nil
      expect(c.doctor).to eql nil
      doc = FactoryGirl.create(:doctor)
      ids = [a.id.to_s, b.id.to_s, c.id.to_s]
      # Stub out call to Google Calendar
      expect(Calendar).to receive(:gcal_event_update).at_least(:once)
      errors = Shift.assign_shifts(ids, doc)
      a = Shift.find(a.id)
      b = Shift.find(b.id)
      c = Shift.find(c.id)
      expect(a.confirmed).to eql true
      expect(b.confirmed).to eql true
      expect(c.confirmed).to eql true
      expect(a.doctor).to eql doc
      expect(b.doctor).to eql doc
      expect(c.doctor).to eql doc
    end

    it 'should return an error if at least one shift is already confirmed' do
      a = FactoryGirl.create(:shift, {confirmed: true})
      b = FactoryGirl.create(:shift)
      expect(a.confirmed).to eql true
      expect(b.confirmed).to eql false
      ids = [a.id.to_s, b.id.to_s]
      doc = FactoryGirl.create(:doctor)
      # Stub out call to Google Calendar
      expect(Calendar).to receive(:gcal_event_update).at_least(:once)
      errors = Shift.assign_shifts(ids, doc)
      expect(errors[:claimed_shifts]).to eql [a]
    end

    it 'should return an error if the update fails.' do
      allow(Shift).to receive(:transaction).and_return(false)
      a = FactoryGirl.create(:shift)
      ids = [a.id.to_s]
      doc = FactoryGirl.create(:doctor)
      errors = Shift.assign_shifts(ids, doc)
      expect(errors[:failed_save]).to eql "Failed to save shift assignments. Please try again."
    end
  end

  describe 'creating a shift from a ruby hash with data from google calendar' do
    it 'should successfully create an event given valid data' do
      hash = {
        start_datetime: DateTime.new(2015, 2, 15, 8, 00),
        end_datetime: DateTime.new(2015, 3, 14, 8, 00),
        gcal_event_etag: "some string idc",
        gcal_event_id: "whoa long string",
      }

      shift_errors = Shift.send(:create_shift_from_hash, hash, 1)
      expect(shift_errors).to eql nil
    end

    it 'should successfully return an error as a sentence if validations fail' do
      hash = {
        start_datetime: DateTime.new(2015, 3, 15, 8, 00),
        end_datetime: DateTime.new(2015, 2, 14, 8, 00),
        gcal_event_etag: "some string idc",
        gcal_event_id: "whoa long string",
      }

      shift_errors = Shift.send(:create_shift_from_hash, hash, 1)
      expect(shift_errors).to eql "Sanity check end time can't be before the start time"
    end
  end

  describe 'create shifts from Google Calendar data given start and end times' do
    it 'should successfully create an event if we get data back from the API' do
      response = double("response", status: 200)
      hash = {
        start_datetime: DateTime.new(2015, 2, 15, 8, 00),
        end_datetime: DateTime.new(2015, 3, 14, 8, 00),
        gcal_event_etag: "some string idc",
        gcal_event_id: "whoa long string",
      }
      expect(Calendar).to receive(:gcal_get_events_in_range).and_return(response)
      expect(Shift).to receive(:parse_gcal_json).and_return([hash])


      errors = Shift.create_shifts_for_pay_period(DateTime.new(2015, 2, 14, 8, 00), DateTime.new(2015, 3, 15, 8, 00), 1)
      expect(errors).to eql({})
    end

    it "should return error messages if saving a model fails." do 
      response = double("response", status: 200)
      hash = {
        start_datetime: DateTime.new(2015, 2, 15, 8, 00),
        end_datetime: DateTime.new(2015, 3, 14, 8, 00),
        gcal_event_etag: "some string idc",
        gcal_event_id: "whoa long string",
      }
      expect(Calendar).to receive(:gcal_get_events_in_range).and_return(response)
      expect(Shift).to receive(:parse_gcal_json).and_return([hash])
      expect(Shift).to receive(:create_shift_from_hash).and_return("I'm an error")
      errors = Shift.create_shifts_for_pay_period(DateTime.new(2015, 2, 14, 8, 00), DateTime.new(2015, 3, 15, 8, 00), 1)
      expect(errors).to eql({:shift_save => ["I'm an error"]})
    end

    it "should return an error message if the request to Google fails" do 
      
      # Hacked to stub out all the random requests to other methods
      response = double("response", status: 404, body: {"error" => {"code" => "404", "message" => "world is ending"}})
      
      expect(Calendar).to receive(:gcal_get_events_in_range).and_return(response)
      expect(JSON).to receive(:parse).and_return(response.body)
      errors = Shift.create_shifts_for_pay_period(DateTime.new(2015, 2, 14, 8, 00), DateTime.new(2015, 3, 15, 8, 00), 1)
      
      expected = {request_error: "HTTP 404 -- world is ending"}

      expect(errors).to eql expected
    end
  end

  describe 'parse_gcal_json' do
    it 'should correctly coerce JSON returned from Google Calendar API to our internal representation.' do
      response = {
       "kind": "calendar#events",
       "etag": "\"1430011440062000\"",
       "summary": "ermoonlighter@gmail.com",
       "updated": "2015-04-26T01:24:00.062Z",
       "timeZone": "America/Los_Angeles",
       "accessRole": "owner",
       "defaultReminders": [
        {
         "method": "popup",
         "minutes": 30
        }
       ],
       "nextSyncToken": "CLC8o9_nksUCELC8o9_nksUCGAU=",
       "items": [
        {

         "kind": "calendar#event",
         "etag": "\"2859377892880000\"",
         "id": "gf1jjlo8snq38ci48f33ip7qq8",
         "status": "confirmed",
         "htmlLink": "https://www.google.com/calendar/event?eid=Z2YxampsbzhzbnEzOGNpNDhmMzNpcDdxcTggZXJtb29ubGlnaHRlckBt",
         "created": "2015-04-22T07:49:06.000Z",
         "updated": "2015-04-22T07:49:06.440Z",
         "summary": "Joe Biden",
         "creator": {
          "email": "264516961636-krd6qqi0ks41a0bcs31n2smed0qi4ug9@developer.gserviceaccount.com"
         },
         "organizer": {
          "email": "ermoonlighter@gmail.com",
          "displayName": "er moonlighter",
          "self": true
         },
         "start": {
          "dateTime": "2015-04-22T00:48:55-07:00"
         },
         "end": {
          "dateTime": "2015-04-22T02:48:55-07:00"
         },
         "iCalUID": "gf1jjlo8snq38ci48f33ip7qq8@google.com",
         "sequence": 0,
         "extendedProperties": {
          "private": {
           "id": "37"
          }
         },
         "reminders": {
          "useDefault": true
         }
        },
        {

         "kind": "calendar#event",
         "etag": "\"2859379162166000\"",
         "id": "huh3a85j41l7kobjgvr8l7s7m4",
         "status": "confirmed",
         "htmlLink": "https://www.google.com/calendar/event?eid=aHVoM2E4NWo0MWw3a29iamd2cjhsN3M3bTQgZXJtb29ubGlnaHRlckBt",
         "created": "2015-04-22T07:59:41.000Z",
         "updated": "2015-04-22T07:59:41.083Z",
         "summary": "Joe Biden",
         "creator": {
          "email": "264516961636-krd6qqi0ks41a0bcs31n2smed0qi4ug9@developer.gserviceaccount.com"
         },
         "organizer": {
          "email": "ermoonlighter@gmail.com",
          "displayName": "er moonlighter",
          "self": true
         },
         "start": {
          "dateTime": "2015-04-22T00:59:36-07:00"
         },
         "end": {
          "dateTime": "2015-04-22T02:59:36-07:00"
         },
         "iCalUID": "huh3a85j41l7kobjgvr8l7s7m4@google.com",
         "sequence": 0,
         "extendedProperties": {
          "private": {
           "id": "38"
          }
         },
         "reminders": {
          "useDefault": true
         }
        }
      ]
      }
      api_response = double(body: response)
      expected = [
        {
          start_datetime: DateTime.strptime("2015-04-22T00:48:55-07:00"),
          end_datetime: DateTime.strptime("2015-04-22T02:48:55-07:00"),
          gcal_event_id: "gf1jjlo8snq38ci48f33ip7qq8",
          gcal_event_etag: "\"2859377892880000\""
        },
        {
          start_datetime: DateTime.strptime("2015-04-22T00:59:36-07:00"),
          end_datetime: DateTime.strptime("2015-04-22T02:59:36-07:00"),
          gcal_event_etag: "\"2859379162166000\"",
          gcal_event_id: "huh3a85j41l7kobjgvr8l7s7m4",
        }
      ]
      expect(JSON).to receive(:parse).and_return(response.deep_stringify_keys!)
      data = Shift.parse_gcal_json(api_response)
      expect(data).to eql(expected)
    end
  end

  describe "Shift.delete_completed_shifts" do
    before do
      Timecop.freeze(DateTime.new(2015, 4, 1, 12, 0, 0))
      stub_const("Doctor::MAX_TIME_SINCE_LAST_SHIFT", 3)
    end

    it 'should delete all shifts that have occurred but leave pending shifts untouched' do
      
      # These shifts are in the past.
      doc_to_check = FactoryGirl.create(:doctor, email: "test1@example.com")
      random_doctor = FactoryGirl.create(:doctor, email: "test2@example.com")
      FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(days: -1), end_datetime: DateTime.now.advance(days: -1, hours: 3), doctor: doc_to_check)
      FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(days: -3), end_datetime: DateTime.now.advance(days: -3, hours: 3), doctor: random_doctor)
      FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(days: -5), end_datetime: DateTime.now.advance(days: -5, hours: 3), doctor: random_doctor)
      # This shift is in the future
      FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(days: 1), end_datetime: DateTime.now.advance(days: 1, hours: 3), doctor: random_doctor)
      expect(Shift.all.length).to eql(4)
      Shift.delete_completed_shifts
      expect(Shift.all.length).to eql(1)
      expect(Doctor.find_by_id(doc_to_check.id).last_shift_completion_date).to eql(DateTime.now.advance(days: -1, hours: 3).to_date)
    end

    it 'should leave shifts that are in progress intact.' do 
      random_doctor = FactoryGirl.create(:doctor, email: "test1@example.com") 
      # These shifts are in the past.
      FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(days: -1), end_datetime: DateTime.now.advance(days: -1, hours: 3), doctor: random_doctor)
      FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(days: -3), end_datetime: DateTime.now.advance(days: -3, hours: 3), doctor: random_doctor)
      FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(days: -5), end_datetime: DateTime.now.advance(days: -5, hours: 3), doctor: random_doctor)
    
      # This shift is in progress.
      a = FactoryGirl.create(:shift, start_datetime: DateTime.now.advance(hours: -2), end_datetime: DateTime.now.advance(hours: 1), doctor: random_doctor)
      expect(Shift.all.length).to eql(4)
      Shift.delete_completed_shifts
      expect(Shift.all.length).to eql(1)
    end
  end
end
