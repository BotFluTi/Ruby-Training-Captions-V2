# frozen_string_literal: true

require "rails_helper"

RSpec.describe "MemeAuth", type: :request do
  let(:body) { file_fixture("meme_test.json").read }
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  before do
    User.create!(username: "burnetete", password: "ananas", token: "valid-token")
    allow(MemeService).to receive(:create).and_return("images/generated_123.png")
  end

  it "rejects a request without an authorization header" do
    post "/memes", params: body, headers: headers

    expect(response).to have_http_status(:unauthorized)
  end

  it "rejects an invalid token" do
    post "/memes", params: body, headers: headers.merge("HTTP_AUTHORIZATION" => "Bearer invalid-token")

    expect(response).to have_http_status(:unauthorized)
  end

  it "accepts a valid token and redirects to the generated meme" do
    post "/memes", params: body, headers: headers.merge("HTTP_AUTHORIZATION" => "Bearer valid-token")

    expect(response).to have_http_status(:temporary_redirect)
    expect(response.headers["Location"]).to end_with("/memes/generated_123.png")
  end
end
