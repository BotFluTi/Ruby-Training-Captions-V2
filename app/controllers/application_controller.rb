class ApplicationController < ActionController::API
  include Authentication

  rescue_from ExistingUserError, with: :render_conflict
  rescue_from ValidationError, with: :render_validation_errors

  private

  def render_conflict
    head :conflict
  end

  def render_validation_errors(error)
    render json: { errors: error.errors }, status: :bad_request
  end
end
