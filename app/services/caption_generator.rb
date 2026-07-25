# frozen_string_literal: true

class CaptionGenerator
  OUTPUT_FOLDER = Rails.root.join("images", "generated")

  def initialize(file_path, text)
    @file_path = file_path
    @text = text
  end

  def generate
    FileUtils.mkdir_p(OUTPUT_FOLDER)

    caption_file_name = File.basename(file_path)
                            .sub(/\Aoriginal_/, "caption_")

    caption_path = OUTPUT_FOLDER.join(caption_file_name).to_s
    image = MiniMagick::Image.open(file_path)

    image.combine_options do |options|
      options.gravity "north"
      options.fill "black"
      options.undercolor "white"
      options.font "Arial"
      options.pointsize 20
      options.draw %(text 0,20 "#{text}")
    end

    image.write(caption_path)
    caption_path
  end

  private

  attr_reader :file_path, :text
end
