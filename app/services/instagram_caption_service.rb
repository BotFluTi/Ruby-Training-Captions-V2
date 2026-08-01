# frozen_string_literal: true

class InstagramCaptionService
  def initialize(caption)
    @caption = caption
  end

  def create
    case caption.type
    when "image"
      generate_image
    when "color"
      generator.generate_color
    when "gradient"
      generator.generate_gradient
    end
  end

  private

  attr_reader :caption

  def generate_image
    original_path = ImageDownloader.download(caption.url)
    return nil unless original_path

    generator.generate_image(original_path)
  end

  def generator
    @generator ||= InstagramCaptionGenerator.new(caption)
  end
end
