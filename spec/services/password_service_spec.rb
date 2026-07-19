# frozen_string_literal: true

require "rails_helper"

RSpec.describe PasswordService do
  describe ".encrypt" do
    it "returns a BCrypt hash" do
      encrypted_password = described_class.encrypt("ananas")

      expect(BCrypt::Password.new(encrypted_password)).to eq("ananas")
    end
  end

  describe ".matches?" do
    let(:encrypted_password) { described_class.encrypt("ananas") }

    it "accepts the correct password" do
      expect(described_class.matches?("ananas", encrypted_password)).to be(true)
    end

    it "rejects an incorrect password" do
      expect(described_class.matches?("wrong-password", encrypted_password)).to be(false)
    end
  end
end
