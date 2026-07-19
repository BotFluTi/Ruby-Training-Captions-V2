# frozen_string_literal: true

class AuthorizationService
  def self.authorized?(authorization_header)
    header_parts = authorization_header.to_s.split
    return false unless header_parts.length == 2

    scheme, token = header_parts
    scheme == "Bearer" && User.exists?(token: token)
  end
end
