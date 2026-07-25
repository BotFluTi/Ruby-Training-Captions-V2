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
      generate_gradient: caption_path
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
end
