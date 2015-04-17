# Literally copied this entire file from this link:
# https://wiki.terena.org/plugins/servlet/mobile#content/view/23691293
#
# I take no responsibility for the quality of this code.

module Calendar
  require 'google/api_client'
  extend ActiveSupport::Concern

  API_VERSION = 'v3'
  CACHED_API_FILE = "calendar-#{API_VERSION}.cache"
  CALENDAR_ID = ENV['gcal_id']

  # It's really dumb that we have to do this, here is a link w/ more info: 
  # http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
  # 
  # In short, 'including' a module mixes in only instance methods. 'extend'ing 
  # allows you get class methods, but it doesn't make sense to do it both.
  # So we have our module mix in a class method because abstraction
  # def self.included(base)
  #   base.extend(ClassMethods)
  # end

  def gcal_event_insert
    params = {
      calendarId: CALENDAR_ID
    }
    result = client.execute(
      :api_method => calendar.events.insert,
      :parameters => params,
      :body_object => convert_to_gcal_event
    )
    logger.debug(result.data.to_yaml)
    result
  end

  def gcal_event_update
    params = {
      calendarId: CALENDAR_ID,
      eventId: self.gcal_id
    }
    result = client.execute(
      :api_method => calendar.events.update,
      :parameters => params,
      :body_object => convert_to_gcal_event
    )
    logger.debug(result.data.to_yaml)
  end

  def gcal_event_delete
    params = {
      calendarId: CALENDAR_ID,
      eventId: self.gcal_id
    }
    result = client.execute(
      :api_method => calendar.events.delete,
      :parameters => params
    )
    logger.debug(result.data.to_yaml)
  end

  # module ClassMethods
  #   # NEED TO ADD q parameter so that I can only get events back with '***'
  #   def gcal_get_events_in_range(start_datetime, end_datetime)
  #     params = {
  #       calendarId: CALENDAR_ID,
  #       q: "***".encode!('utf-8'),
  #       timeMin: start_datetime,
  #       timeMax: end_datetime
  #     }

  #     puts params
  #     result = client.execute(
  #       :api_method => calendar.events.list,
  #       :parameters => params
  #     )
  #   end
  # end


  # THIS METHOD SUCKS! EVENTUALLY WE WANT TO MAKE THIS A CLASS METHOD
  # but we can't because even if we use the solution above, those use
  # private methods that we don't want to define twice.
  # In the meantime, call this with Shift.new.gcal_get_events_in_range.
  def gcal_get_events_in_range(start_datetime, end_datetime)
    params = {
      calendarId: CALENDAR_ID,
      q: "***".encode!('utf-8'),
      timeMin: start_datetime,
      timeMax: end_datetime
    }

    puts params
    result = client.execute(
      :api_method => calendar.events.list,
      :parameters => params
    )
  end

private
  def convert_to_gcal_event
    event = {
      'summary' => self.name,
      'description' => self.description,
      'start' => {
         'dateTime' => self.tstart
      },
      'end' => {
         'dateTime' => self.tend
      },
      'location' => get_event_location,
      'extendedProperties' => {
        'private' => {
          'id' => self.id
        }
      }
    }
  end

  def get_event_location
    [self.location.try(:name),
      self.location.try(:address),
      self.location.try(:city),
      self.location.try(:country)].compact.join(", ")
  end

  def init_client

    client = Google::APIClient.new(:application_name => 'EventR', :application_version => '1.0.0')
    
    key = Google::APIClient::KeyUtils.load_from_pkcs12('key.p12', "notasecret")
    client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/calendar',
      :issuer => ENV['gcal_client_email'],
      # :person => Rails.application.secrets.google_cal['client_email'],
      :signing_key => key)

    # Request a token for our service account
    client.authorization.fetch_access_token!
    client
  end

  def init_calendar
    @calendar = nil
    # Load cached discovered API, if it exists. This prevents retrieving the
    # discovery document on every run, saving a round-trip to the discovery service.
    if File.exists? CACHED_API_FILE
      File.open(CACHED_API_FILE) do |file|
        @calendar = Marshal.load(file)
      end
    else
      @calendar = @client.discovered_api('calendar', API_VERSION)
      File.open(CACHED_API_FILE, 'w') do |file|
        Marshal.dump(@calendar, file)
      end
    end
  end

  def client
    @client ||= init_client
  end

  def calendar
    @calendar ||= init_calendar
  end

end
