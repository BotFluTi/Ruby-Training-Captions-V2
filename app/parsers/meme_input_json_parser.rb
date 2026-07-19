# frozen_string_literal: true

class MemeInputJsonParser
  def parse(body)
    meme_data = build_meme_data(body)
    error_message = validation_error(meme_data)

    raise ValidationError.new([ { message: error_message } ]) if error_message

    meme_data
  end

  private

  def build_meme_data(body)
    return nil unless body.is_a?(Hash) && body.any?

    root = body["meme"]
    return nil unless root.is_a?(Hash) && root.any?

    MemeData.new(root["image_url"], root["text"])
  end

  def validation_error(meme_data)
    return "Empty body" unless meme_data
    return "Check URL field" if missing?(meme_data.image_url)

    "Check text field" if missing?(meme_data.text)
  end

  def missing?(value)
    value.nil? || value.empty?
  end
end
