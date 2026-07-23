# frozen_string_literal: true

require "open-uri"
require "securerandom"

class ImageDownloader
  FOLDER_PATH = Rails.root.join("images")

  def self.download(url)
    FileUtils.mkdir_p(FOLDER_PATH)
    file_path = FOLDER_PATH.join("original_#{SecureRandom.uuid}.png").to_s

    URI.open(url) do |image|
      File.binwrite(file_path, image.read)
    end

    file_path
  rescue StandardError
    nil
  end
end
