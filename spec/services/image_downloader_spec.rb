# frozen_string_literal: true

require "rails_helper"
require "securerandom"

RSpec.describe ImageDownloader do
  describe ".download" do
    let(:url) { "https://example.com/image.png" }
    let(:image) do
      double(
        "downloaded image",
        read: "image content",
        content_type: "image/png"
      )
    end
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

    %w[image/jpg image/jpeg image/png].each do |content_type|
      it "accepts #{content_type}" do
        allow(image).to receive(:content_type).and_return(content_type)

        expect(described_class.download(url)).not_to be_nil
      end
    end

    context "when the content type is not supported" do
      before do
        allow(image).to receive(:content_type).and_return("text/plain")
      end

      it "returns nil" do
        expect(described_class.download(url)).to be_nil
      end

      it "does not save the file" do
        described_class.download(url)

        expect(File).not_to have_received(:binwrite)
      end
    end
  end
end
