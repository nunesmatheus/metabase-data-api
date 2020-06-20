# frozen_string_literal: true

class Api::EventsController < Api::ApplicationController
  def create
    return unless require_params(:name)

    EventCreatorService.call(params[:options] || {})
    event = Event.create(event_params)

    if event.persisted?
      render json: event
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  private

  def event_params
    geolocation = Geocoder.search(request.ip).first
    user_agent = UserAgent.parse(request.user_agent)
    {
      name: params[:name], ocurred_at: params[:ocurred_at],
      country: geolocation&.country, state: geolocation&.state,
      city: geolocation&.city, browser: user_agent.browser,
      browser_version: user_agent.version, platform: user_agent.platform
    }.merge(params[:options]&.permit! || {})
  end
end
