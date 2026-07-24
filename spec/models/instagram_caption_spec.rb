# frozen_string_literal: true

require "rails_helper"

RSpec.describe InstagramCaption, type: :model do
  it "stores an image caption" do
    caption = described_class.create!(
      type: "image",
      url: "https://example.com/image.jpg",
      text: "Image caption",
      filter: "blackwhite",
      caption_url: "http://example.com/images/instagram_1.png"
    )

    expect(caption).to have_attributes(
                         type: "image",
                         url: "https://example.com/image.jpg",
                         text: "Image caption",
                         filter: "blackwhite",
                         caption_url: "http://example.com/images/instagram_1.png"
                       )
  end

  it "stores a color caption" do
    caption = described_class.create!(
      type: "color",
      color: "#003166",
      text: "Color caption",
      caption_url: "http://example.com/images/instagram_2.png"
    )

    expect(caption).to have_attributes(
                         type: "color",
                         color: "#003166",
                         text: "Color caption",
                         caption_url: "http://example.com/images/instagram_2.png"
                       )
  end

  it "stores a gradient caption" do
    caption = described_class.create!(
      type: "gradient",
      start_color: "#000000",
      end_color: "#003166",
      text: "Gradient caption",
      caption_url: "http://example.com/images/instagram_3.png"
    )

    expect(caption).to have_attributes(
                         type: "gradient",
                         start_color: "#000000",
                         end_color: "#003166",
                         text: "Gradient caption",
                         caption_url: "http://example.com/images/instagram_3.png"
                       )
  end

  describe "validations" do
    it "rejects an unsupported type" do
      caption = described_class.new(
        type: "video",
        text: "Caption text"
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:type]).to include("is not included in the list")
    end

    it "requires text" do
      caption = described_class.new(
        type: "color",
        color: "#003166",
        text: ""
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:text]).to include("is blank")
    end

    it "rejects text longer than 266 characters" do
      caption = described_class.new(
        type: "color",
        color: "#003166",
        text: "a" * 267
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:text]).to include(
                                         "is too long (maximum is 266 characters)"
                                       )
    end

    it "requires a url for an image caption" do
      caption = described_class.new(
        type: "image",
        url: "",
        text: "Caption text"
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:url]).to include("is blank")
    end

    it "requires a valid HEX color for a color caption" do
      caption = described_class.new(
        type: "color",
        color: "blue",
        text: "Caption text"
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:color]).to include("must be a valid HEX color")
    end

    it "requires a valid start color for a gradient caption" do
      caption = described_class.new(
        type: "gradient",
        start_color: "black",
        end_color: "#003166",
        text: "Caption text"
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:start_color]).to include(
                                                "must be a valid HEX color"
                                              )
    end

    it "requires a valid end color for a gradient caption" do
      caption = described_class.new(
        type: "gradient",
        start_color: "#000000",
        end_color: "blue",
        text: "Caption text"
      )

      expect(caption).not_to be_valid
      expect(caption.errors[:end_color]).to include(
                                              "must be a valid HEX color"
                                            )
    end
  end
end
