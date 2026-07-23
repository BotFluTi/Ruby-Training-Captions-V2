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

  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  before do
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
end
