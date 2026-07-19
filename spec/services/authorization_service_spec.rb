# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthorizationService do
  describe ".authorized?" do
    it "accepts a valid Bearer token" do
      allow(User).to receive(:exists?).with(token: "valid-token").and_return(true)

      expect(described_class.authorized?("Bearer valid-token")).to be(true)
    end

    it "rejects an invalid token" do
      allow(User).to receive(:exists?).with(token: "invalid-token").and_return(false)

      expect(described_class.authorized?("Bearer invalid-token")).to be(false)
    end

    it "rejects a missing header" do
      expect(described_class.authorized?(nil)).to be(false)
    end

    it "rejects a different authorization scheme" do
      expect(described_class.authorized?("Basic valid-token")).to be(false)
    end

    it "rejects a malformed header" do
      expect(described_class.authorized?("Bearer token extra-value")).to be(false)
    end
  end
end
