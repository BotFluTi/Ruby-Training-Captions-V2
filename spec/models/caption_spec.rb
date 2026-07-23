# frozen_string_literal: true

require "rails_helper"

RSpec.describe Caption, type: :model do
  it "stores the caption data" do
    caption = described_class.create!(
      url: "https://example.com/image.jpg",
      text: "Caption text",
      caption_url: "http://localhost:3000/images/caption.jpg"
    )

    expect(caption).to have_attributes(
                         url: "https://example.com/image.jpg",
                         text: "Caption text",
                         caption_url: "http://localhost:3000/images/caption.jpg"
                       )
  end

  describe "validations" do
    it "requires a url" do
      caption = described_class.new(
        url: "",
        text: "Caption text",
        caption_url: "http://localhost:3000/images/caption.jpg"
      )

      expect(caption).not_to be_valid
      expect(caption.errors.full_messages).to include("Url is blank")
    end

    it "requires text" do
      caption = described_class.new(
        url: "https://example.com/image.jpg",
        text: "",
        caption_url: "http://localhost:3000/images/caption.jpg"
      )

      expect(caption).not_to be_valid
      expect(caption.errors.full_messages).to include("Text is blank")
    end

    it "accepts text with 266 characters" do
      caption = described_class.new(
        url: "https://example.com/image.jpg",
        text: "a" * 266,
        caption_url: "http://localhost:3000/images/caption.jpg"
      )

      expect(caption).to be_valid
    end

    it "rejects text longer than 266 characters" do
      caption = described_class.new(
        url: "https://example.com/image.jpg",
        text: "a" * 267,
        caption_url: "http://localhost:3000/images/caption.jpg"
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:text])
        .to include("is too long (maximum is 266 characters)")
    end
  end
end
