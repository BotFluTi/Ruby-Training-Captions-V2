# frozen_string_literal: true

class InstagramCaptionsController < ApplicationController
  rescue_from ValidationError, with: :handle_caption_input_error

  def index
    captions = InstagramCaption.order(:id)

    render json: {
      captions: captions.as_json(
        only: %i[id url type text filter caption_url]
      )
    }, status: :ok
  end

  def create
    attributes =
      InstagramCaptionInputJsonParser.new.parse(
        request.request_parameters
      )

    caption = InstagramCaption.new(attributes)

    return handle_invalid_caption(caption) unless caption.valid?

    caption_path = InstagramCaptionService.new(caption).create

    caption.caption_url = caption_image_url(caption_path)
    caption.save!

    render json: {
      caption: caption.slice(
        :id,
        :url,
        :type,
        :text,
        :filter,
        :caption_url
      )
    }, status: :see_other
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
end
