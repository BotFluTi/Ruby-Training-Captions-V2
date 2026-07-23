# frozen_string_literal: true

require "rails_helper"

RSpec.describe InstagramCaptionInputJsonParser do
  subject(:image_attributes) { described_class.new.parse(body) }

  context "when the image input is valid" do
    let(:body) do
      {
        "image" => {
          "type" => "image",
          "url" => "https://example.com/image.jpg",
          "text" => "Caption text",
          "filter" => "blackwhite"
        }
      }
    end

    it "returns the image attributes" do
      expect(image_attributes).to eq(
                                    type: "image",
                                    url: "https://example.com/image.jpg",
                                    text: "Caption text",
                                    filter: "blackwhite"
                                  )
    end
  end

  context "when image is missing" do
    let(:body) { {} }

    it "raises a missing parameters error" do
      expect { image_attributes }.to raise_error(ValidationError) do |error|
        expect(error.errors).to eq(
                                  code: "missing_parameters",
                                  title: "Parameter is missing from the request body",
                                  description: "image parameter is missing from the request body. " \
                                    "It is a required parameter and the request cannot be processed."
                                )
      end
    end
  end

  context "when type is missing" do
    let(:body) do
      {
        "image" => {
          "url" => "https://example.com/image.jpg",
          "text" => "Caption text"
        }
      }
    end

    it "raises a missing parameters error" do
      expect { image_attributes }.to raise_error(ValidationError) do |error|
        expect(error.errors).to eq(
                                  code: "missing_parameters",
                                  title: "Parameter is missing from the request body",
                                  description: "type parameter is missing from the request body. " \
                                    "It is a required parameter and the request cannot be processed."
                                )
      end
    end
  end
end
