# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /memes", type: :request do
  let(:body) { file_fixture("meme_test.json").read }
  let(:service_result) { "images/generated_123.png" }
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json",
      "HTTP_AUTHORIZATION" => "Bearer valid-token"
    }
  end

  before do
    User.create!(username: "burnetete", password: "ananas", token: "valid-token")
    allow(MemeService).to receive(:create).and_return(service_result)
    post "/memes", params: body, headers: headers
  end

  context "when the request is correct" do
    it "returns status code 307" do
      expect(response).to have_http_status(:temporary_redirect)
    end
  end

  context "when the request is missing the image URL" do
    let(:body) { file_fixture("no_link_test.json").read }

    it "returns the original validation response" do
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body["message"]).to eq("Check URL field")
    end
  end

  context "when the request is missing text" do
    let(:body) { file_fixture("no_text_test.json").read }

    it "returns the original validation response" do
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body["message"]).to eq("Check text field")
    end
  end

  context "when the request body is empty" do
    let(:body) { file_fixture("empty_json_test.json").read }

    it "returns the original validation response" do
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body["message"]).to eq("Empty body")
    end
  end

  context "when the image cannot be downloaded" do
    let(:body) { file_fixture("wrong_url_test.json").read }
    let(:service_result) { nil }

    it "returns the original service error" do
      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body["message"]).to eq("Failed to download image")
    end
  end
end

RSpec.describe "GET /memes/:file", type: :request do
  let(:file_name) { "generated_request_spec.png" }
  let(:file_path) { Rails.root.join("images", file_name) }

  before do
    FileUtils.mkdir_p(file_path.dirname)
    File.binwrite(file_path, "generated image")
  end

  after do
    FileUtils.rm_f(file_path)
  end

  it "returns the generated image" do
    get "/memes/#{file_name}"

    expect(response).to have_http_status(:ok)
    expect(response.body).to eq("generated image")
  end
end
