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
      shift = FactoryGirl.create(:shift, {start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 3, 15, 13, 00)})
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
end
