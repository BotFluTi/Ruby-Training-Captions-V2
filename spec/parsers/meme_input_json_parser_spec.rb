# frozen_string_literal: true

require "rails_helper"

RSpec.describe MemeInputJsonParser do
  subject(:parse) { described_class.new.parse(body) }

  context "when the input is valid" do
    let(:body) do
      {
        "meme" => {
          "image_url" => "https://example.com/image.jpg",
          "text" => "Hello world"
        }
      }
    end

    it "returns meme data" do
      expect(parse).to be_a(MemeData)
    end

    it "parses the image URL" do
      expect(parse.image_url).to eq("https://example.com/image.jpg")
    end

    it "parses the text" do
      expect(parse.text).to eq("Hello world")
    end
  end

  context "when the body is empty" do
    let(:body) { {} }

    it "raises an empty body validation error" do
      expect { parse }
        .to raise_error(ValidationError) { |error| expect(error.errors).to include(message: "Empty body") }
    end
  end

  context "when the image URL is missing" do
    let(:body) { { "meme" => { "text" => "Hello world" } } }

    it "raises an image URL validation error" do
      expect { parse }
        .to raise_error(ValidationError) { |error| expect(error.errors).to include(message: "Check URL field") }
    end
  end

  context "when the text is missing" do
    let(:body) { { "meme" => { "image_url" => "https://example.com/image.jpg" } } }

    it "raises a text validation error" do
      expect { parse }
        .to raise_error(ValidationError) { |error| expect(error.errors).to include(message: "Check text field") }
    end
  end
end
