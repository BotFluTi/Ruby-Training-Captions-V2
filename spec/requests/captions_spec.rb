# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /captions", type: :request do
  let(:body) do
    {
      caption: {
        text: "Caption text"
      }
    }.to_json
  end

  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json",
      "HTTP_HOST" => "example.com"
    }
  end

  let(:caption_path) { "images/caption_123.png" }

  before do
    allow(CaptionService).to receive(:create).and_return(caption_path)

    post "/captions", params: body, headers: headers
  end

  context "when url is missing" do
    it "returns status code 400" do
      expect(response).to have_http_status(:bad_request)
    end

    it "returns the missing parameters error" do
      expect(response.parsed_body).to eq(
                                        "code" => "missing_parameters",
                                        "title" => "Parameter is missing from the request body",
                                        "description" => "url parameter is missing from the request body. " \
                                          "It is a required parameter and the request cannot be processed."
                                      )
    end
  end

  context "when url is empty" do
    let(:body) do
      {
        caption: {
          url: "",
          text: "Caption text"
        }
      }.to_json
    end

    it "returns status code 422" do
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns the invalid parameter error" do
      expect(response.parsed_body).to eq(
                                        "code" => "invalid_parameters",
                                        "title" => "Parameter has an invalid value",
                                        "description" => "url parameter is blank."
                                      )
    end
  end

  context "when url has an incorrect name" do
    let(:body) do
      {
        caption: {
          uri: "https://example.com/image.jpg",
          text: "Caption text"
        }
      }.to_json
    end

    it "returns status code 400" do
      expect(response).to have_http_status(:bad_request)
    end

    it "returns the missing URL error" do
      expect(response.parsed_body).to eq(
                                        "code" => "missing_parameters",
                                        "title" => "Parameter is missing from the request body",
                                        "description" => "url parameter is missing from the request body. " \
                                          "It is a required parameter and the request cannot be processed."
                                      )
    end
  end

  context "when text is empty" do
    let(:body) do
      {
        caption: {
          url: "https://example.com/image.jpg",
          text: ""
        }
      }.to_json
    end

    it "returns status code 422" do
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns the invalid parameter error" do
      expect(response.parsed_body).to eq(
                                        "code" => "invalid_parameters",
                                        "title" => "Parameter has an invalid value",
                                        "description" => "text parameter is blank."
                                      )
    end
  end

  context "when text is missing" do
    let(:body) do
      {
        caption: {
          url: "https://example.com/image.jpg"
        }
      }.to_json
    end

    it "returns status code 400" do
      expect(response).to have_http_status(:bad_request)
    end

    it "returns the missing parameters error" do
      expect(response.parsed_body).to eq(
                                        "code" => "missing_parameters",
                                        "title" => "Parameter is missing from the request body",
                                        "description" => "text parameter is missing from the request body. " \
                                          "It is a required parameter and the request cannot be processed."
                                      )
    end
  end

  context "when the image cannot be downloaded" do
    let(:body) do
      {
        caption: {
          url: "https://example.com/missing-image.jpg",
          text: "Caption text"
        }
      }.to_json
    end

    let(:caption_path) { nil }

    it "returns status code 422" do
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "does not save the caption" do
      expect(
        Caption.find_by(url: "https://example.com/missing-image.jpg")
      ).to be_nil
    end

    it "returns the invalid URL error" do
      expect(response.parsed_body).to eq(
                                        "code" => "invalid_parameters",
                                        "title" => "Parameter has an invalid value",
                                        "description" => "url parameter does not point to a downloadable image."
                                      )
    end
  end

  context "when text exceeds 266 characters" do
    let(:body) do
      {
        caption: {
          url: "https://example.com/image.jpg",
          text: "a" * 267
        }
      }.to_json
    end

    it "returns status code 422" do
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns the invalid parameter error" do
      expect(response.parsed_body).to eq(
                                        "code" => "invalid_parameters",
                                        "title" => "Parameter has an invalid value",
                                        "description" => "text parameter is too long (maximum is 266 characters)."
                                      )
    end
  end

  context "when parameters are valid" do
    let(:body) do
      {
        caption: {
          url: "https://example.com/image.jpg",
          text: "Caption text"
        }
      }.to_json
    end

    it "returns status code 201" do
      expect(response).to have_http_status(:created)
    end

    it "saves the caption" do
      expect(Caption.last).to have_attributes(
                                url: "https://example.com/image.jpg",
                                text: "Caption text",
                                caption_url: "http://example.com/images/caption_123.png"
                              )
    end

    it "returns the created caption" do
      caption = Caption.last

      expect(response.parsed_body).to eq(
                                        "caption" => {
                                          "id" => caption.id,
                                          "url" => "https://example.com/image.jpg",
                                          "text" => "Caption text",
                                          "caption_url" => "http://example.com/images/caption_123.png"
                                        }
                                      )
    end
  end
end

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
