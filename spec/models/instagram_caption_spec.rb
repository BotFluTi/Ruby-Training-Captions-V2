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
end
