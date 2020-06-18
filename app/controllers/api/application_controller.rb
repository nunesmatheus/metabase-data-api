class Api::ApplicationController < ActionController::API
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