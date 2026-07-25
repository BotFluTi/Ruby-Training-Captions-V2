# frozen_string_literal: true

require "rails_helper"

RSpec.describe InstagramCaptionService do
  subject(:service) { described_class.new(caption) }

  let(:caption_path) do
    "images/generated/instagram_123.png"
  end

  let(:generator) do
    instance_double(
      InstagramCaptionGenerator,
      generate_color: caption_path,
      generate_gradient: caption_path,
      generate_image: caption_path
    )
  end

  before do
    allow(InstagramCaptionGenerator)
      .to receive(:new)
            .with(caption)
            .and_return(generator)
  end

  context "when the caption type is color" do
    let(:caption) do
      instance_double(
        InstagramCaption,
        type: "color"
      )
    end

    it "generates and returns the color background" do
      result = service.create

      expect(generator).to have_received(:generate_color)
      expect(generator).not_to have_received(:generate_gradient)
      expect(result).to eq(caption_path)
    end
  end

  context "when the caption type is gradient" do
    let(:caption) do
      instance_double(
        InstagramCaption,
        type: "gradient"
      )
    end

    it "generates and returns the gradient background" do
      result = service.create

      expect(generator).to have_received(:generate_gradient)
      expect(generator).not_to have_received(:generate_color)
      expect(result).to eq(caption_path)
    end
  end

  context "when the caption type is image" do
    let(:url) { "https://example.com/image.png" }

    let(:caption) do
      instance_double(
        InstagramCaption,
        type: "image",
        url: url
      )
    end

    context "when the image is downloaded successfully" do
      let(:original_path) { "images/original_123.png" }

      before do
        allow(ImageDownloader)
          .to receive(:download)
                .with(url)
                .and_return(original_path)
      end

      it "downloads and generates the image caption" do
        result = service.create

        expect(ImageDownloader)
          .to have_received(:download)
                .with(url)

        expect(generator)
          .to have_received(:generate_image)
                .with(original_path)

        expect(generator).not_to have_received(:generate_color)
        expect(generator).not_to have_received(:generate_gradient)
        expect(result).to eq(caption_path)
      end
    end

    context "when the image cannot be downloaded" do
      before do
        allow(ImageDownloader)
          .to receive(:download)
                .with(url)
                .and_return(nil)
      end

      it "returns nil without generating an image" do
        result = service.create

        expect(result).to be_nil
        expect(InstagramCaptionGenerator).not_to have_received(:new)
      end
    end
  end
end
