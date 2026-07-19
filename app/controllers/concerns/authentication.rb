# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  private

  def authenticate!
    return if AuthorizationService.authorized?(request.headers["Authorization"])

    head :unauthorized
  end
end
