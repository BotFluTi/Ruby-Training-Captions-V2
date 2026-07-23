# frozen_string_literal: true

class CaptionGenerator
  def self.generate(file_path, text)
    caption_path = file_path.sub(/original_/, "caption_")
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
