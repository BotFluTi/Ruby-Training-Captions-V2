# frozen_string_literal: true

class MemeService
  def self.create(meme_data)
    original_path = ImageDownloader.download(meme_data.image_url)
    return nil unless original_path

    MemeGenerator.generate(original_path, meme_data.text)
  end
end
