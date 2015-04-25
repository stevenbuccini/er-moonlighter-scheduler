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
      errors = Shift.assign_multiple_shifts(ids, doc)
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
      errors = Shift.assign_multiple_shifts(ids, doc)
      expect(errors[:claimed_shifts]).to eql [a]
    end

    it 'should return an error if the update fails.' do
      allow(Shift).to receive(:transaction).and_return(false)
      a = FactoryGirl.create(:shift)
      ids = [a.id.to_s]
      doc = FactoryGirl.create(:doctor)
      errors = Shift.assign_multiple_shifts(ids, doc)
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
      expect(Shift).to receive(:parse_gcal_json).and_return([hash])
      expect(Shift).to receive(:create_shift_from_hash).and_return(nil)


      errors = Shift.create_shifts_for_pay_period(DateTime.new(2015, 2, 14, 8, 00), DateTime.new(2015, 3, 15, 8, 00), 1)
      expect(errors).to eql({})
    end

    it "should return error messages if saving a model fails." do 
      response = double("response", status: 200)
      blah = Shift.new
      expect(Shift).to receive(:new).and_return(blah)
      expect(blah).to receive(:gcal_get_events_in_range).and_return(response)
      expect(Shift).to receive(:create_shift_from_hash).and_return("I'm an error")
      hash = {
        start_datetime: DateTime.new(2015, 2, 15, 8, 00),
        end_datetime: DateTime.new(2015, 3, 14, 8, 00),
        gcal_event_etag: "some string idc",
        gcal_event_id: "whoa long string",
      }
      expect(Shift).to receive(:parse_gcal_json).and_return([hash])
      errors = Shift.create_shifts_for_pay_period(DateTime.new(2015, 2, 14, 8, 00), DateTime.new(2015, 3, 15, 8, 00), 1)
      expect(errors).to eql({:shift_save => ["I'm an error"]})
    end

    it "should return an error message if the request to Google fails" do 
      
      # Hacked to stub out all the random requests to other methods
      response = double("response", status: 404, body: {"error" => {"code" => "404", "message" => "world is ending"}})
      blah = Shift.new
      expect(Shift).to receive(:new).and_return(blah)
      expect(blah).to receive(:gcal_get_events_in_range).and_return(response)
      expect(JSON).to receive(:parse).and_return(response.body)
      errors = Shift.create_shifts_for_pay_period(DateTime.new(2015, 2, 14, 8, 00), DateTime.new(2015, 3, 15, 8, 00), 1)
      
      expected = {request_error: "HTTP 404 -- world is ending"}

      expect(errors).to eql expected
    end
  end
end
