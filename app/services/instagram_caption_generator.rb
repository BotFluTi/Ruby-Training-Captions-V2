# frozen_string_literal: true

require "securerandom"

class InstagramCaptionGenerator
  OUTPUT_FOLDER = Rails.root.join("public", "images")
  INSTAGRAM_SIZE = "1080x1080"

  def self.generate_color(caption)
    generate_background("xc:#{caption.color}")
  end

  def self.generate_gradient(caption)
    generate_background(
      "gradient:#{caption.start_color}-#{caption.end_color}"
    )
  end

  def self.generate_background(background)
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

  private_class_method :generate_background
end