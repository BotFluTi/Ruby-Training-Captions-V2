# frozen_string_literal: true

require "rails_helper"

RSpec.describe CaptionGenerator do
  describe ".generate" do
    let(:original_path) { "images/original_123.png" }
    let(:caption_path) { "images/caption_123.png" }
    let(:text) { "Caption text" }
    let(:image) { instance_double(MiniMagick::Image) }
    let(:options) do
      double(
        "image options",
        gravity: nil,
        fill: nil,
        undercolor: nil,
        font: nil,
        pointsize: nil,
        draw: nil
      )
    end

    before do
      allow(MiniMagick::Image)
        .to receive(:open)
              .with(original_path)
              .and_return(image)

      allow(image).to receive(:combine_options).and_yield(options)
      allow(image).to receive(:write)
    end

    it "adds the caption at the top of the image" do
      described_class.generate(original_path, text)

      expect(options).to have_received(:gravity).with("north")
      expect(options).to have_received(:fill).with("black")
      expect(options).to have_received(:undercolor).with("white")
      expect(options).to have_received(:font).with("Arial")
      expect(options).to have_received(:pointsize).with(20)
      expect(options).to have_received(:draw).with(%(text 0,20 "#{text}"))
    end

    it "writes and returns the caption image" do
      result = described_class.generate(original_path, text)

      expect(image).to have_received(:write).with(caption_path)
      expect(result).to eq(caption_path)
    end
  end
end
