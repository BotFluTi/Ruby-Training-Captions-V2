# frozen_string_literal: true

require "rails_helper"

RSpec.describe MemeService do
  describe ".create" do
    let(:meme_data) { MemeData.new("https://example.com/image.png", "Text for Test") }
    let(:original_path) { "images/original_123.png" }
    let(:generated_path) { "images/generated_123.png" }

    context "when the image is downloaded successfully" do
      before do
        allow(ImageDownloader).to receive(:download).with(meme_data.image_url).and_return(original_path)
        allow(MemeGenerator).to receive(:generate).with(original_path, meme_data.text).and_return(generated_path)
      end

      it "returns the generated image path" do
        expect(described_class.create(meme_data)).to eq(generated_path)
      end
    end

    context "when the image cannot be downloaded" do
      before do
        allow(ImageDownloader).to receive(:download).with(meme_data.image_url).and_return(nil)
        allow(MemeGenerator).to receive(:generate)
      end

      it "returns nil without generating an image" do
        expect(described_class.create(meme_data)).to be_nil
        expect(MemeGenerator).not_to have_received(:generate)
      end
    end
  end
end
