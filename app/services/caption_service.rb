# frozen_string_literal: true

class CaptionService
  def self.create(caption)
    original_path = ImageDownloader.download(caption.url)
    return nil unless original_path

    CaptionGenerator.new(original_path, caption.text).generate
  end

  def self.destroy(caption)
    caption_file_name = File.basename(caption.caption_url)
    original_file_name = caption_file_name.sub(/\Acaption_/, "original_")

    FileUtils.rm_f(
      CaptionGenerator::OUTPUT_FOLDER.join(caption_file_name)
    )

    FileUtils.rm_f(
      ImageDownloader::FOLDER_PATH.join(original_file_name)
    )

    caption.destroy!
  end
end
