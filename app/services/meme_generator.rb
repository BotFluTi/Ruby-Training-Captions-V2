# frozen_string_literal: true

class MemeGenerator
  def self.generate(file_path, text)
    generated_file_path = file_path.sub(/original_/, "generated_")
    image = MiniMagick::Image.open(file_path)

    image.combine_options do |options|
      options.gravity "center"
      options.fill "black"
      options.undercolor "white"
      options.font "Arial"
      options.pointsize 20
      options.draw %(text 0,50 "#{text}")
    end

    image.write(generated_file_path)
    generated_file_path
  end
end
