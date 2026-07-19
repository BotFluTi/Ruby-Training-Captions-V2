# frozen_string_literal: true

require "rails_helper"
require "stringio"

RSpec.describe ImageDownloader do
  describe ".download" do
    let(:url) { "https://example.com/image.png" }
    let(:image) { StringIO.new("image content") }

    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(URI).to receive(:open).with(url).and_yield(image)
      allow(File).to receive(:binwrite)
    end

    it "saves and returns the downloaded image path" do
      result = described_class.download(url)

      expect(File).to have_received(:binwrite).with(result, "image content")
      expect(result).to match(%r{images/original_\d+\.png\z})
    end

    it "returns nil when the image cannot be downloaded" do
      allow(URI).to receive(:open).with(url).and_raise(StandardError)

      expect(described_class.download(url)).to be_nil
    end
  end
end
