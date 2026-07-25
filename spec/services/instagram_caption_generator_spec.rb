# frozen_string_literal: true

require "rails_helper"

RSpec.describe InstagramCaptionGenerator do
  subject(:generator) { described_class.new(caption) }

  let(:uuid) { "123e4567-e89b-42d3-a456-426614174000" }

  let(:caption_path) do
    Rails.root.join(
      "images",
      "generated",
      "instagram_#{uuid}.png"
    ).to_s
  end

  let(:convert) do
    double(
      "image command",
      size: nil
    )
  end

  before do
    allow(convert).to receive(:<<)

    allow(MiniMagick)
      .to receive(:convert)
            .and_yield(convert)

    allow(FileUtils).to receive(:mkdir_p)
    allow(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  describe "#generate_color" do
    let(:caption) do
      instance_double(
        InstagramCaption,
        color: "#003166"
      )
    end

    it "creates the output folder" do
      generator.generate_color

      expect(FileUtils)
        .to have_received(:mkdir_p)
              .with(Rails.root.join("images", "generated"))
    end

    it "creates a square Instagram background" do
      generator.generate_color

      expect(convert).to have_received(:size).with("1080x1080")
      expect(convert).to have_received(:<<).with("xc:#003166")
    end

    it "writes and returns a uniquely named image" do
      result = generator.generate_color

      expect(convert).to have_received(:<<).with(caption_path)
      expect(result).to eq(caption_path)
    end
  end

  describe "#generate_gradient" do
    let(:caption) do
      instance_double(
        InstagramCaption,
        start_color: "#000000",
        end_color: "#003166"
      )
    end

    it "creates a square Instagram gradient" do
      generator.generate_gradient

      expect(convert).to have_received(:size).with("1080x1080")

      expect(convert)
        .to have_received(:<<)
              .with("gradient:#000000-#003166")
    end

    it "writes and returns a uniquely named image" do
      result = generator.generate_gradient

      expect(convert).to have_received(:<<).with(caption_path)
      expect(result).to eq(caption_path)
    end
  end

  describe "#generate_image" do
    let(:caption) { instance_double(InstagramCaption) }
    let(:original_path) { "images/original_123.png" }
    let(:width) { 800 }
    let(:height) { 800 }

    let(:image) do
      double(
        "image",
        width: width,
        height: height,
        resize: nil,
        gravity: nil,
        extent: nil,
        write: nil
      )
    end

    before do
      allow(MiniMagick::Image)
        .to receive(:open)
              .with(original_path)
              .and_return(image)
    end

    context "when the image width is below 320 pixels" do
      let(:width) { 200 }
      let(:height) { 200 }

      it "resizes the image to 320 pixels" do
        generator.generate_image(original_path)

        expect(image).to have_received(:resize).with("320x")
      end
    end

    context "when the image dimensions are supported" do
      it "keeps the original dimensions" do
        generator.generate_image(original_path)

        expect(image).not_to have_received(:resize)
        expect(image).not_to have_received(:extent)
      end
    end

    context "when the image width exceeds 1080 pixels" do
      let(:width) { 1500 }
      let(:height) { 1500 }

      it "resizes the image to 1080 pixels" do
        generator.generate_image(original_path)

        expect(image).to have_received(:resize).with("1080x")
      end
    end

    context "when the image is too wide" do
      let(:width) { 800 }
      let(:height) { 300 }

      it "crops the image to the maximum aspect ratio" do
        generator.generate_image(original_path)

        expect(image).to have_received(:resize).with("800x419^")
        expect(image).to have_received(:gravity).with("center")
        expect(image).to have_received(:extent).with("800x419")
      end
    end

    context "when the image is too tall" do
      let(:width) { 800 }
      let(:height) { 1200 }

      it "crops the image to the minimum aspect ratio" do
        generator.generate_image(original_path)

        expect(image).to have_received(:resize).with("800x1066^")
        expect(image).to have_received(:gravity).with("center")
        expect(image).to have_received(:extent).with("800x1066")
      end
    end

    it "writes and returns a uniquely named image" do
      result = generator.generate_image(original_path)

      expect(image).to have_received(:write).with(caption_path)
      expect(result).to eq(caption_path)
    end
  end
end
