# frozen_string_literal: true

class PasswordService
  def self.encrypt(password)
    BCrypt::Password.create(password).to_s
  end

  def self.matches?(password, password_digest)
    BCrypt::Password.new(password_digest) == password
  end
end
