# frozen_string_literal: true

require "rails_helper"

RSpec.describe CaptionService do
  describe ".create" do
    let(:caption) do
      Caption.new(
        url: "https://example.com/image.png",
        text: "Caption text"
      )
    end

    let(:original_path) { "images/original_123.png" }
    let(:caption_path) { "images/caption_123.png" }

    context "when the image is downloaded successfully" do
      before do
        allow(ImageDownloader)
          .to receive(:download)
                .with(caption.url)
                .and_return(original_path)

        allow(CaptionGenerator)
          .to receive(:generate)
                .with(original_path, caption.text)
                .and_return(caption_path)
      end

      it "returns the generated caption image path" do
        expect(described_class.create(caption)).to eq(caption_path)
      end
    end

    context "when the image cannot be downloaded" do
      before do
        allow(ImageDownloader)
          .to receive(:download)
                .with(caption.url)
                .and_return(nil)

        allow(CaptionGenerator).to receive(:generate)
      end

      it "returns nil without generating a caption image" do
        expect(described_class.create(caption)).to be_nil
        expect(CaptionGenerator).not_to have_received(:generate)
      end
    end
  end
end
