# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SignUp", type: :request do
  let(:body) { file_fixture("signup_test.json").read }
  let(:response_body) { response.parsed_body }
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  before do
    post "/signup", params: body, headers: headers
  end

  context "when the username is blank" do
    let(:body) { file_fixture("signup_no_username.json").read }

    it "returns status code 400 with a username validation error" do
      expect(response).to have_http_status(:bad_request)
      expect(response_body["errors"]).to include("message" => "Username is blank")
    end
  end

  context "when the password is blank" do
    let(:body) { file_fixture("signup_no_password.json").read }

    it "returns status code 400 with a password validation error" do
      expect(response).to have_http_status(:bad_request)
      expect(response_body["errors"]).to include("message" => "Password is blank")
    end
  end

  context "when the user data is valid" do
    it "returns status code 201 and an authentication token" do
      expect(response).to have_http_status(:created)
      expect(response_body.dig("user", "token")).to be_a(String)
    end
  end

  context "when the username already exists" do
    before do
      post "/signup", params: body, headers: headers
    end

    it "returns status code 409" do
      expect(response).to have_http_status(:conflict)
    end
  end
end
