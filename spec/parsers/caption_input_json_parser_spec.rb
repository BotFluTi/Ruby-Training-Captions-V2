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
end
