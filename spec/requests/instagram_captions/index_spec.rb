# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /captions/instagrams", type: :request do
  subject(:send_request) { get "/captions/instagrams" }

  context "when there are no instagram captions" do
    it "returns status code 200" do
      send_request

      expect(response).to have_http_status(:ok)
    end

    it "returns an empty collection" do
      send_request

      expect(response.parsed_body).to eq(
                                        "captions" => []
                                      )
    end
  end

  context "when an instagram caption exists" do
    let!(:caption) do
      InstagramCaption.create!(
        type: "image",
        url: "https://example.com/image.jpg",
        text: "Caption text",
        filter: "blackwhite",
        caption_url: "http://example.com/images/instagram_123.png"
      )
    end

    it "returns the instagram captions" do
      send_request

      expect(response.parsed_body).to eq(
                                        "captions" => [
                                          {
                                            "id" => caption.id,
                                            "url" => caption.url,
                                            "type" => caption.type,
                                            "text" => caption.text,
                                            "filter" => caption.filter,
                                            "caption_url" => caption.caption_url
                                          }
                                        ]
                                      )
    end
  end
end
