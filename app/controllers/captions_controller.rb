# frozen_string_literal: true

class CaptionsController < ApplicationController
  rescue_from ValidationError, with: :render_caption_input_error

  def create
    attributes = CaptionInputJsonParser.new.parse(request.request_parameters)
    caption = Caption.new(attributes)

    render_invalid_caption(caption) unless caption.valid?
  end

  private

  def render_caption_input_error(error)
    render json: error.errors, status: :bad_request
  end

  def render_invalid_caption(caption)
    error = caption.errors.first

    render json: {
      code: "invalid_parameters",
      title: "Parameter has an invalid value",
      description: "#{error.attribute} parameter #{error.message}."
    }, status: :unprocessable_content
  end
end
