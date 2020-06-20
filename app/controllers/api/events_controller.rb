# frozen_string_literal: true

module Api
  class EventsController < ApplicationController
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
      default_params.merge(geolocation_attributes).merge(agent_attributes)
    end

    def default_params
      params.permit(:name, :ocurred_at).merge(params[:options]&.permit! || {})
    end

    def geolocation_attributes
      geolocation = Geocoder.search(request.remote_ip).first
      return {} unless geolocation

      {
        country: geolocation.country, state: geolocation.state,
        city: geolocation.city
      }
    end

    def agent_attributes
      user_agent = UserAgent.parse(request.user_agent)

      {
        browser: user_agent.browser, browser_version: user_agent.version,
        platform: user_agent.platform
      }
    end
  end
end
