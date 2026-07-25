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
end
