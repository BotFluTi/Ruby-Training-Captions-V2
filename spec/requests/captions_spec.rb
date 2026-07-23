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
