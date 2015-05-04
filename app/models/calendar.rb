# Almost copied this entire file verbatim from this link:
# https://wiki.terena.org/plugins/servlet/mobile#content/view/23691293
#
# I take no responsibility for the quality of this code.

class Calendar
  require 'google/api_client'
  extend ActiveSupport::Concern

  API_VERSION = 'v3'
  CACHED_API_FILE = "calendar-#{API_VERSION}.cache"
  CALENDAR_ID = ENV["gcal_calendar_id"]

  # It's really dumb that we have to do this, here is a link w/ more info:
  # http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
  #
  # In short, 'including' a module mixes in only instance methods. 'extend'ing
  # allows you get class methods, but it doesn't make sense to do it both.
  # So we have our module mix in a class method because abstraction
  # def self.included(base)
  #   base.extend(ClassMethods)
  # end


  def self.gcal_event_insert(shift)
    params = {
      calendarId: CALENDAR_ID,
    }
    result = client.execute(
      :api_method => calendar.events.insert,
      :parameters => params,
      :body_object => Calendar.convert_to_gcal_event(shift)
    )
  end

  def self.gcal_event_update(shift)
    params = {
      calendarId: CALENDAR_ID,
      eventId: shift.gcal_event_id
    }
    result = client.execute(
      :api_method => calendar.events.update,
      :parameters => params,
      :body_object => Calendar.convert_to_gcal_event(shift)
    )
  end

  def self.gcal_event_delete(shift)
    params = {
      calendarId: CALENDAR_ID,
      eventId: shift.gcal_event_id
    }
    result = client.execute(
      :api_method => calendar.events.delete,
      :parameters => params
    )
  end

  def self.gcal_get_events_in_range(start_datetime, end_datetime)
    params = {
      calendarId: CALENDAR_ID,
      #q: "***".encode!('utf-8'),
      q: "(open)",
      timeMin: start_datetime.to_datetime.iso8601, #FORMATTING ISSUES HERE
      timeMax: end_datetime.to_datetime.iso8601  #FORMATTING ISSUES HERE
    }

    result = client.execute(
      :api_method => calendar.events.list,
      :parameters => params
    )
  end

private
  def self.convert_to_gcal_event(shift)
    event = {
      'summary' => shift.doctor.full_name,
      'start' => {
         'dateTime' => shift.start_datetime
      },
      'end' => {
         'dateTime' => shift.end_datetime
      },
      'extendedProperties' => {
        'private' => {
          'id' => shift.id
        }
      }
    }
  end

  def self.init_client

    client = Google::APIClient.new(:application_name => 'Moonlighter', :application_version => '1.0.0')

    key = OpenSSL::PKey::RSA.new(ENV["gcal_private_key"])

    client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/calendar',
      :issuer => ENV["gcal_cal_service_email"],
      # :person => Rails.application.secrets.google_cal['client_email'],
      :signing_key => key)

    # Request a token for our service account
    client.authorization.fetch_access_token!
    client
  end

  def self.init_calendar
    @@calendar = nil
    # Load cached discovered API, if it exists. This prevents retrieving the
    # discovery document on every run, saving a round-trip to the discovery service.
    if File.exists? CACHED_API_FILE
      File.open(CACHED_API_FILE) do |file|
        @@calendar = Marshal.load(file)
      end
    else
      @@calendar = @client.discovered_api('calendar', API_VERSION)
      File.open(CACHED_API_FILE, 'w') do |file|
        Marshal.dump(@calendar, file)
      end
    end
  end

  def self.client
    @@client ||= init_client
  end

  def self.calendar
    @@calendar ||= init_calendar
  end

end
