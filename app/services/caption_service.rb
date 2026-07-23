# frozen_string_literal: true

class CaptionService
  def self.create(caption)
    original_path = ImageDownloader.download(caption.url)
    return nil unless original_path

    CaptionGenerator.generate(original_path, caption.text)
  end
end
