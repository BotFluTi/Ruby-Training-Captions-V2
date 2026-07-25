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
      let(:generator) do
        instance_double(
          CaptionGenerator,
          generate: caption_path
        )
      end

      before do
        allow(ImageDownloader)
          .to receive(:download)
                .with(caption.url)
                .and_return(original_path)

        allow(CaptionGenerator)
          .to receive(:new)
                .with(original_path, caption.text)
                .and_return(generator)
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

        allow(CaptionGenerator).to receive(:new)
      end

      it "returns nil without generating a caption image" do
        expect(described_class.create(caption)).to be_nil
        expect(CaptionGenerator).not_to have_received(:new)
      end
    end
  end

  describe ".destroy" do
    let(:caption) do
      instance_double(
        Caption,
        caption_url: "http://example.com/images/caption_123.png",
        destroy!: true
      )
    end

    let(:caption_path) do
      CaptionGenerator::OUTPUT_FOLDER.join("caption_123.png")
    end

    let(:original_path) do
      ImageDownloader::FOLDER_PATH.join("original_123.png")
    end

    before do
      allow(FileUtils).to receive(:rm_f)
    end

    it "removes the generated and original images" do
      described_class.destroy(caption)

      expect(FileUtils).to have_received(:rm_f).with(caption_path)
      expect(FileUtils).to have_received(:rm_f).with(original_path)
    end

    it "deletes the caption record" do
      described_class.destroy(caption)

      expect(caption).to have_received(:destroy!)
    end
  end
end
