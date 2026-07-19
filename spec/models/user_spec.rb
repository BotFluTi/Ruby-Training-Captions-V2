# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "validations" do
    it "requires a username" do
      user = described_class.new(username: "", password: "ananas", token: "test-token")

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Username is blank")
    end

    it "requires a password when the user is created" do
      user = described_class.new(username: "burnetete", token: "test-token")

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password is blank")
    end

    it "requires a unique username" do
      described_class.create!(username: "burnetete", password: "ananas", token: "first-token")
      duplicate = described_class.new(username: "burnetete", password: "ananas", token: "second-token")

      expect(duplicate).not_to be_valid
    end

    it "requires a unique token" do
      described_class.create!(username: "burnetete", password: "ananas", token: "same-token")
      duplicate = described_class.new(username: "second-user", password: "ananas", token: "same-token")

      expect(duplicate).not_to be_valid
    end
  end

  describe "password security" do
    subject(:user) { described_class.new(password: password) }

    let(:password) { "ananas" }

    it "stores the password as a BCrypt hash" do
      expect(BCrypt::Password.new(user.password_digest)).to eq(password)
    end

    it "authenticates the correct password" do
      expect(user.authenticate(password)).to eq(user)
    end

    it "rejects an incorrect password" do
      expect(user.authenticate("wrong-password")).to be(false)
    end
  end
end
