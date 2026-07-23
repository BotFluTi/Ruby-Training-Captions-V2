# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /captions", type: :request do
  subject(:send_request) { get "/captions" }

  context "when captions exist" do
    let!(:first_caption) do
      Caption.create!(
        url: "https://example.com/first.jpg",
        text: "First caption",
        caption_url: "http://example.com/images/caption_first.png"
      )
    end

    let!(:second_caption) do
      Caption.create!(
        url: "https://example.com/second.jpg",
        text: "Second caption",
        caption_url: "http://example.com/images/caption_second.png"
      )
    end

    before do
      send_request
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end

    it "returns all captions" do
      expect(response.parsed_body).to eq(
                                        "captions" => [
                                          {
                                            "id" => first_caption.id,
                                            "url" => first_caption.url,
                                            "text" => first_caption.text,
                                            "caption_url" => first_caption.caption_url
                                          },
                                          {
                                            "id" => second_caption.id,
                                            "url" => second_caption.url,
                                            "text" => second_caption.text,
                                            "caption_url" => second_caption.caption_url
                                          }
                                        ]
                                      )
    end
  end

  context "when no captions exist" do
    before do
      send_request
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end

    it "returns an empty collection" do
      expect(response.parsed_body).to eq(
                                        "captions" => []
                                      )
    end
  end
end
