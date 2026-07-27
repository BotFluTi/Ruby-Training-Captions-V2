# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /captions/instagram", type: :request do
  subject(:send_request) do
    post "/captions/instagram",
         params: body,
         headers: headers
  end

  let(:body) do
    {
      image: {
        type: "color",
        color: "#003166",
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

  it "returns status code 303" do
    send_request

    expect(response).to have_http_status(:see_other)
  end

  it "sets caption URL in location" do
    send_request

    expect(response.headers["Location"]).to eq(
                                              "http://example.com/images/instagram_123.png"
                                            )
  end

  it "generates the instagram caption" do
    send_request

    expect(InstagramCaptionService)
      .to have_received(:new)
            .with(
              an_object_having_attributes(
                type: "color",
                color: "#003166",
                text: "Caption text"
              )
            )

    expect(service).to have_received(:create)
  end

  it "saves the instagram caption" do
    send_request

    expect(InstagramCaption.last).to have_attributes(
                                       type: "color",
                                       color: "#003166",
                                       text: "Caption text",
                                       caption_url: "http://example.com/images/instagram_123.png"
                                     )
  end

  it "returns the created instagram caption" do
    send_request

    caption = InstagramCaption.last

    expect(response.parsed_body).to eq(
                                      "caption" => {
                                        "id" => caption.id,
                                        "url" => nil,
                                        "type" => "color",
                                        "text" => "Caption text",
                                        "filter" => nil,
                                        "caption_url" => "http://example.com/images/instagram_123.png"
                                      }
                                    )
  end

  context "when the caption type is image" do
    let(:body) do
      {
        image: {
          type: "image",
          url: "https://example.com/image.jpg",
          text: "Image caption",
          filter: "blackwhite"
        }
      }.to_json
    end

    it "saves the image caption attributes" do
      send_request

      expect(InstagramCaption.last).to have_attributes(
                                         type: "image",
                                         url: "https://example.com/image.jpg",
                                         text: "Image caption",
                                         filter: "blackwhite",
                                         caption_url: "http://example.com/images/instagram_123.png"
                                       )
    end

    it "returns the image caption" do
      send_request

      caption = InstagramCaption.last

      expect(response.parsed_body).to eq(
                                        "caption" => {
                                          "id" => caption.id,
                                          "url" => "https://example.com/image.jpg",
                                          "type" => "image",
                                          "text" => "Image caption",
                                          "filter" => "blackwhite",
                                          "caption_url" => "http://example.com/images/instagram_123.png"
                                        }
                                      )
    end
  end

  context "when the caption type is gradient" do
    let(:body) do
      {
        image: {
          type: "gradient",
          start_color: "#000000",
          end_color: "#003166",
          text: "Gradient caption"
        }
      }.to_json
    end

    it "saves the gradient caption attributes" do
      send_request

      expect(InstagramCaption.last).to have_attributes(
                                         type: "gradient",
                                         start_color: "#000000",
                                         end_color: "#003166",
                                         text: "Gradient caption",
                                         caption_url: "http://example.com/images/instagram_123.png"
                                       )
    end

    it "returns the gradient caption" do
      send_request

      caption = InstagramCaption.last

      expect(response.parsed_body).to eq(
                                        "caption" => {
                                          "id" => caption.id,
                                          "url" => nil,
                                          "type" => "gradient",
                                          "text" => "Gradient caption",
                                          "filter" => nil,
                                          "caption_url" => "http://example.com/images/instagram_123.png"
                                        }
                                      )
    end
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
