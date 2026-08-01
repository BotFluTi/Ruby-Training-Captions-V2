# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /captions/instagram errors", type: :request do
  subject(:send_request) do
    post "/captions/instagram",
         params: body,
         headers: headers
  end

  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json",
      "HTTP_HOST" => "example.com"
    }
  end

  let(:caption_path) do
    "images/generated/instagram_123.png"
  end

  let(:service) do
    instance_double(
      InstagramCaptionService,
      create: caption_path
    )
  end

  before do
    allow(InstagramCaptionService)
      .to receive(:new)
            .and_return(service)
  end

  context "when type is missing" do
    let(:body) do
      {
        image: {
          color: "#003166",
          text: "Caption text"
        }
      }.to_json
    end

    it "returns status code 400" do
      send_request

      expect(response).to have_http_status(:bad_request)
    end

    it "returns the missing parameters error" do
      send_request

      expect(response.parsed_body).to eq(
                                        "code" => "missing_parameters",
                                        "title" => "Parameter is missing from the request body",
                                        "description" => "type parameter is missing from the request body. " \
                                          "It is a required parameter and the request cannot be processed."
                                      )
    end

    it "does not generate a caption" do
      send_request

      expect(InstagramCaptionService).not_to have_received(:new)
    end
  end

  context "when color is invalid" do
    let(:body) do
      {
        image: {
          type: "color",
          color: "blue",
          text: "Caption text"
        }
      }.to_json
    end

    it "returns status code 422" do
      send_request

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns the invalid parameter error" do
      send_request

      expect(response.parsed_body).to eq(
                                        "code" => "invalid_parameters",
                                        "title" => "Parameter has an invalid value",
                                        "description" => "color parameter must be a valid HEX color."
                                      )
    end

    it "does not generate a caption" do
      send_request

      expect(InstagramCaptionService).not_to have_received(:new)
    end
  end

  context "when the image cannot be downloaded" do
    let(:body) do
      {
        image: {
          type: "image",
          url: "https://example.com/missing-image.jpg",
          text: "Caption text"
        }
      }.to_json
    end

    let(:caption_path) { nil }

    it "returns status code 422" do
      send_request

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns the invalid URL error" do
      send_request

      expect(response.parsed_body).to eq(
                                        "code" => "invalid_parameters",
                                        "title" => "Parameter has an invalid value",
                                        "description" => "url parameter does not point to a downloadable image."
                                      )
    end

    it "does not save the instagram caption" do
      send_request

      expect(
        InstagramCaption.find_by(
          url: "https://example.com/missing-image.jpg"
        )
      ).to be_nil
    end
  end
end
