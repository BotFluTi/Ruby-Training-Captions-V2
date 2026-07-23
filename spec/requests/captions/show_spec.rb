# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /captions/:id", type: :request do
  subject(:send_request) { get "/captions/#{caption_id}" }

  context "when the caption exists" do
    let!(:caption) do
      Caption.create!(
        url: "https://example.com/image.jpg",
        text: "Caption text",
        caption_url: "http://example.com/images/caption_123.png"
      )
    end

    let(:caption_id) { caption.id }

    before do
      send_request
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end

    it "returns the caption" do
      expect(response.parsed_body).to eq(
                                        "caption" => {
                                          "id" => caption.id,
                                          "url" => caption.url,
                                          "text" => caption.text,
                                          "caption_url" => caption.caption_url
                                        }
                                      )
    end
  end

  context "when the caption does not exist" do
    let(:caption_id) { Caption.maximum(:id).to_i + 1 }

    before do
      send_request
    end

    it "returns status code 404" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the caption not found error" do
      expect(response.parsed_body).to eq(
                                        "code" => "caption_not_found",
                                        "title" => "Caption not found",
                                        "description" => "Caption with id #{caption_id} was not found."
                                      )
    end
  end
end
