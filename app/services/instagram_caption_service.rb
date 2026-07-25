# frozen_string_literal: true

class InstagramCaptionService
  def initialize(caption)
    @caption = caption
  end

  def create
    generator = InstagramCaptionGenerator.new(caption)

    case caption.type
    when "color"
      generator.generate_color
    when "gradient"
      generator.generate_gradient
    end
  end

  private

  attr_reader :caption
end
