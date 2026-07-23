# frozen_string_literal: true

class CaptionsController < ApplicationController
  rescue_from ValidationError, with: :render_caption_input_error

  def create
    CaptionInputJsonParser.new.parse(request.request_parameters)
  end

  private

  def render_caption_input_error(error)
    render json: error.errors, status: :bad_request
  end
end
