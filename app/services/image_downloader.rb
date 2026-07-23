# frozen_string_literal: true

require "open-uri"
require "securerandom"

class ImageDownloader
  FOLDER_PATH = Rails.root.join("images")
  SUPPORTED_CONTENT_TYPES = %w[image/jpg image/jpeg image/png].freeze

  def self.download(url)
    FileUtils.mkdir_p(FOLDER_PATH)
    file_path = FOLDER_PATH.join("original_#{SecureRandom.uuid}.png").to_s

    URI.open(url) do |image|
      return nil unless SUPPORTED_CONTENT_TYPES.include?(image.content_type)

      File.binwrite(file_path, image.read)
    end

    file_path
  rescue StandardError
    nil
  end
end
