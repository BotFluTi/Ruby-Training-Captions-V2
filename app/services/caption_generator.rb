# frozen_string_literal: true

class CaptionGenerator
  OUTPUT_FOLDER = Rails.root.join("public", "images")

  def self.generate(file_path, text)
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
end
