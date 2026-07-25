# frozen_string_literal: true

require "securerandom"

class InstagramCaptionGenerator
  OUTPUT_FOLDER = Rails.root.join("images", "generated")
  INSTAGRAM_SIZE = "1080x1080"

  def initialize(caption)
    @caption = caption
  end

  def generate_color
    generate_background("xc:#{caption.color}")
  end

  def generate_gradient
    generate_background(
      "gradient:#{caption.start_color}-#{caption.end_color}"
    )
  end

  private

  attr_reader :caption

  def generate_background(background)
    FileUtils.mkdir_p(OUTPUT_FOLDER)

    caption_path = OUTPUT_FOLDER.join(
      "instagram_#{SecureRandom.uuid}.png"
    ).to_s

    MiniMagick.convert do |convert|
      convert.size INSTAGRAM_SIZE
      convert << background
      convert << caption_path
    end

    caption_path
  end
end
