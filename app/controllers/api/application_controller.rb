# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    def require_authentication
      return unless ENV['API_TOKEN'].present?

      token = request.headers['Authorization']&.sub(/Bearer +/, '')
      return if ENV['API_TOKEN'] == token

      render json: { error: 'Your API token is either missing or invalid' },
             status: :unauthorized
    end

    def require_params(*required_params)
      required_params = required_params.map(&:to_s)
      return true if (params.keys & required_params).size == required_params.size

      render json: {
                      error: I18n.t('controllers.base.missing_required_params',
                                    params: required_params.join(', '))
                   },
             status: :unprocessable_entity
      false
    end
  end
end
