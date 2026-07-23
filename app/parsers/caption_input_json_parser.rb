# frozen_string_literal: true

class CaptionInputJsonParser
  def parse(body)
    caption = body["caption"]

    {
      url: caption["url"],
      text: caption["text"]
    }
  end
end
