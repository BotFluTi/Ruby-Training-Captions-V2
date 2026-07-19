# frozen_string_literal: true

class MemesController < ApplicationController
  before_action :authenticate!, only: :create

  rescue_from ValidationError, with: :render_meme_input_error

  def create
    meme_data = MemeInputJsonParser.new.parse(JSON.parse(request.raw_post))
    generated_path = MemeService.create(meme_data)

    return render_generation_error unless generated_path

    redirect_to meme_path(file: File.basename(generated_path)), status: :temporary_redirect
  end

  def show
    file_name = File.basename(params[:file])
    send_file Rails.root.join("images", file_name)
  end

  private

  def render_meme_input_error(error)
    render json: { message: error.errors.first[:message] }, status: :bad_request
  end

  def render_generation_error
    render json: { message: "Failed to download image" }, status: :bad_request
  end
end
