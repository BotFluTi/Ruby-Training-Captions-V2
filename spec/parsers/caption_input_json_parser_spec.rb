# frozen_string_literal: true

require "rails_helper"

RSpec.describe CaptionInputJsonParser do
  subject(:caption_attributes) { described_class.new.parse(body) }

  context "when the input is valid" do
    let(:body) do
      {
        "caption" => {
          "url" => "https://example.com/image.jpg",
          "text" => "Caption text"
        }
      }
    end

    it "returns the caption attributes" do
      expect(caption_attributes).to eq(
                                      url: "https://example.com/image.jpg",
                                      text: "Caption text"
                                    )
    end
  end

  context "when caption is missing" do
    let(:body) { {} }

    it "raises a validation error" do
      expect { caption_attributes }.to raise_error(ValidationError)
    end
  end

  context "when url is missing" do
    let(:body) do
      {
        "caption" => {
          "text" => "Caption text"
        }
      }
    end

    it "raises a missing parameters error" do
      expect { caption_attributes }.to raise_error(ValidationError) do |error|
        expect(error.errors).to eq(
                                  code: "missing_parameters",
                                  title: "Parameter is missing from the request body",
                                  description: "url parameter is missing from the request body. " \
                                    "It is a required parameter and the request cannot be processed."
                                )
      end
    end
  end

  context "when text is missing" do
    let(:body) do
      {
        "caption" => {
          "url" => "https://example.com/image.jpg"
        }
      }
    end

    it "raises a validation error" do
      expect { caption_attributes }.to raise_error(ValidationError)
    end
  end
end
