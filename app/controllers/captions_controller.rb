# frozen_string_literal: true

class CaptionsController < ApplicationController
  rescue_from ValidationError, with: :render_caption_input_error

  def create
    attributes = CaptionInputJsonParser.new.parse(request.request_parameters)
    caption = Caption.new(attributes)

    return head :unprocessable_content unless caption.valid?
  end

  private

  def render_caption_input_error(error)
    render json: error.errors, status: :bad_request
  end
end
