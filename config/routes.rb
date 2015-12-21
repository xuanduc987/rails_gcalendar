Rails.application.routes.draw do
  root to: "calendars#index"
  get "/oauth2callback" => "oauths#callback"
end
