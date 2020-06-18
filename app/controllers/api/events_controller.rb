class Api::EventsController < Api::ApplicationController
  def create
    return if !require_params(:name)

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
    {
      name: params[:name], ocurred_at: params[:ocurred_at]
    }.merge(params[:options]&.permit! || {})
  end
end
