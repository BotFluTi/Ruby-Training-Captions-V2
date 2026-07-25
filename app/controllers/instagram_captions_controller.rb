# frozen_string_literal: true

class InstagramCaptionsController < ApplicationController
  def index
    captions = InstagramCaption.order(:id)

    render json: {
      captions: captions.as_json(
        only: %i[id url type text filter caption_url]
      )
    }, status: :ok
  end
end
