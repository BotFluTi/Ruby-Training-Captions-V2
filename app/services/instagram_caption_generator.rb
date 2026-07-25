# frozen_string_literal: true

require "securerandom"

class InstagramCaptionGenerator
  OUTPUT_FOLDER = Rails.root.join("images", "generated")
  INSTAGRAM_SIZE = "1080x1080"

  MINIMUM_WIDTH = 320
  MAXIMUM_WIDTH = 1080

  MINIMUM_ASPECT_RATIO = 0.75
  MAXIMUM_ASPECT_RATIO = 1.91

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

  def generate_image(file_path)
    FileUtils.mkdir_p(OUTPUT_FOLDER)

    image = MiniMagick::Image.open(file_path)
    resize_and_crop_image(image)

    output_path = caption_path
    image.write(output_path)

    output_path
  end

  private

  attr_reader :caption

  def generate_background(background)
    FileUtils.mkdir_p(OUTPUT_FOLDER)

    output_path = caption_path

    MiniMagick.convert do |convert|
      convert.size INSTAGRAM_SIZE
      convert << background
      convert << output_path
    end

    output_path
  end

  def resize_and_crop_image(image)
    width = image.width
    height = image.height
    target_width = width.clamp(MINIMUM_WIDTH, MAXIMUM_WIDTH)
    aspect_ratio = width.to_f / height

    if aspect_ratio > MAXIMUM_ASPECT_RATIO
      target_height = (target_width / MAXIMUM_ASPECT_RATIO).ceil
      crop_image(image, target_width, target_height)
    elsif aspect_ratio < MINIMUM_ASPECT_RATIO
      target_height = (target_width / MINIMUM_ASPECT_RATIO).floor
      crop_image(image, target_width, target_height)
    elsif target_width != width
      image.resize("#{target_width}x")
    end
  end

  def crop_image(image, width, height)
    image.resize("#{width}x#{height}^")
    image.gravity("center")
    image.extent("#{width}x#{height}")
  end

  def caption_path
    OUTPUT_FOLDER.join(
      "instagram_#{SecureRandom.uuid}.png"
    ).to_s
  end
end
