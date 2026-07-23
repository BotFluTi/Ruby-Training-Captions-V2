# frozen_string_literal: true

require "rails_helper"
require "stringio"
require "securerandom"

RSpec.describe ImageDownloader do
  describe ".download" do
    let(:url) { "https://example.com/image.png" }
    let(:image) { StringIO.new("image content") }
    let(:uuid) { "123e4567-e89b-12d3-a456-426614174000" }

    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(URI).to receive(:open).with(url).and_yield(image)
      allow(File).to receive(:binwrite)
      allow(SecureRandom).to receive(:uuid).and_return(uuid)
    end

    it "saves and returns the downloaded image path" do
      result = described_class.download(url)

      expect(File).to have_received(:binwrite).with(result, "image content")
      expect(File.basename(result)).to eq("original_#{uuid}.png")
    end

    it "returns nil when the image cannot be downloaded" do
      allow(URI).to receive(:open).with(url).and_raise(StandardError)

      expect(described_class.download(url)).to be_nil
    end
  end
end
