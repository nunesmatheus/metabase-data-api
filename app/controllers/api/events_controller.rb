class Api::EventsController < ApplicationController
  def create
    event = Event.create(event_params)

    if event.persisted?
      render json: event
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.permit(:name, :ocurred_at, options: {})
  end
end
