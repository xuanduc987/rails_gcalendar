class CalendarsController < ApplicationController
  require 'google/apis/calendar_v3'
  require 'google/api_client/client_secrets'

  Calendar = Google::Apis::CalendarV3

  def index
    redirect_to oauth2callback_path and return if session[:token].blank?

    auth_client = Signet::OAuth2::Client.new
    auth_client.update_token!(session[:token])

    client = Calendar::CalendarService.new
    client.authorization = auth_client

    results = client.list_events(
      "primary",
      single_events: true,
      order_by: 'startTime',
      time_min: Time.now.iso8601,
      time_max: 1.month.from_now.iso8601
    )

    display_str = ""
    results.items.each do |event|
      start_date = event.start.date || event.start.date_time
      display_str << "- #{event.summary} (#{start_date})\n"
    end

    render text: display_str
  end
end
