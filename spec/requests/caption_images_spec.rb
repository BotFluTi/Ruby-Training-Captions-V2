# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /images/:file", type: :request do
  let(:file_name) { "caption_test.png" }
  let(:file_path) do
    Rails.root.join("public", "images", file_name)
  end

  before do
    FileUtils.mkdir_p(file_path.dirname)
    File.binwrite(file_path, "generated image")
  end

  after do
    FileUtils.rm_f(file_path)
  end

  it "serves the generated caption image" do
    get "/images/#{file_name}"

    expect(response).to have_http_status(:ok)
    expect(response.body).to eq("generated image")
    expect(response.media_type).to eq("image/png")
  end
end
