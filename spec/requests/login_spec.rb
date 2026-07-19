# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Login", type: :request do
  let(:fixture_body) { file_fixture("signup_test.json").read }
  let(:credentials) { JSON.parse(fixture_body).fetch("user") }
  let(:body) { fixture_body }
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  before do
    User.create!(
      username: credentials["username"],
      password: credentials["password"],
      token: "test-token"
    )

    post "/login", params: body, headers: headers
  end

  context "with correct credentials" do
    it "returns status code 200 and the user token" do
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.dig("user", "token")).to eq("test-token")
    end
  end

  context "with an incorrect password" do
    let(:body) do
      { user: { username: credentials["username"], password: "wrong-password" } }.to_json
    end

    it "returns status code 409" do
      expect(response).to have_http_status(:conflict)
    end
  end

  context "when the username does not exist" do
    let(:body) do
      { user: { username: "unknown-user", password: credentials["password"] } }.to_json
    end

    it "returns status code 409" do
      expect(response).to have_http_status(:conflict)
    end
  end
end
