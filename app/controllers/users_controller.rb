# frozen_string_literal: true

class UsersController < ApplicationController
  def signup
    user_data = parsed_body["user"] || {}
    validate_user_data!(user_data)

    raise ExistingUserError if User.exists?(username: user_data["username"])

    user = build_user(user_data)
    raise ValidationError.new(validation_errors(user)) unless user.save

    render json: { user: { token: user.token } }, status: :created
  end

  def login
    credentials = parsed_body["user"] || {}
    user = User.find_by(username: credentials["username"])
    user = user&.authenticate(credentials["password"])

    return head :conflict unless user

    render json: { user: { token: user.token } }, status: :ok
  end

  private

  def parsed_body
    JSON.parse(request.raw_post)
  end

  def validate_user_data!(user_data)
    errors = []
    errors << { message: "Username is blank" } if user_data["username"].blank?
    errors << { message: "Password is blank" } if user_data["password"].blank?

    raise ValidationError.new(errors) if errors.any?
  end

  def validation_errors(user)
    user.errors.full_messages.map { |message| { message: message } }
  end

  def build_user(user_data)
    User.new(
      username: user_data["username"],
      password: user_data["password"],
      token: SecureRandom.hex(16)
    )
  end
end
