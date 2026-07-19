# frozen_string_literal: true

class MemeData
  attr_reader :image_url, :text

  def initialize(image_url, text)
    @image_url = image_url
    @text = text
  end
end
