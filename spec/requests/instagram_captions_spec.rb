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
end
