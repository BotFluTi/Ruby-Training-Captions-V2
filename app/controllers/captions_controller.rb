# frozen_string_literal: true

class CaptionsController < ApplicationController
  rescue_from ValidationError, with: :handle_caption_input_error

  def index
    captions = Caption.order(:id)

    render json: {
      captions: captions.as_json(
        only: %i[id url text caption_url]
      )
    }, status: :ok
  end

  def create
    attributes = CaptionInputJsonParser.new.parse(request.request_parameters)
    caption = Caption.new(attributes)

    return handle_invalid_caption(caption) unless caption.valid?

    caption_path = CaptionService.create(caption)

    return handle_failed_download unless caption_path

    caption.caption_url = caption_image_url(caption_path)
    caption.save!

    render json: {
      caption: caption.slice(:id, :url, :text, :caption_url)
    }, status: :created
  end

  private

  def caption_image_url(caption_path)
    "#{request.base_url}/images/#{File.basename(caption_path)}"
  end

  def handle_caption_input_error(error)
    render json: error.errors, status: :bad_request
  end

  def handle_invalid_caption(caption)
    error = caption.errors.first

    render json: {
      code: "invalid_parameters",
      title: "Parameter has an invalid value",
      description: "#{error.attribute} parameter #{error.message}."
    }, status: :unprocessable_content
  end

  def handle_failed_download
    render json: {
      code: "invalid_parameters",
      title: "Parameter has an invalid value",
      description: "url parameter does not point to a downloadable image."
    }, status: :unprocessable_content
  end
end
