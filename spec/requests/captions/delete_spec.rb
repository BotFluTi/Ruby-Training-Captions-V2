# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /captions/:id", type: :request do
  subject(:send_request) { delete "/captions/#{caption_id}" }

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
      allow(CaptionService).to receive(:destroy) do |record|
        record.destroy!
      end

      send_request
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end

    it "deletes the caption" do
      expect(Caption.exists?(caption.id)).to be(false)
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
