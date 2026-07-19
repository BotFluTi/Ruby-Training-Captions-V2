# frozen_string_literal: true

require "rails_helper"

RSpec.describe MemeData do
  subject(:meme_data) do
    described_class.new("https://example.com/image.jpg", "Hello world")
  end

  it "stores the image URL" do
    expect(meme_data.image_url).to eq("https://example.com/image.jpg")
  end

  it "stores the text" do
    expect(meme_data.text).to eq("Hello world")
  end
end
