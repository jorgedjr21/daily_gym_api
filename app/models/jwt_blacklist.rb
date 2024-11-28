class JwtBlacklist < ApplicationRecord
   # Validations
   validates :jti, presence: true, uniqueness: true

   # Check if the token is revoked
   def self.jwt_revoked?(payload, _user)
     exists?(jti: payload["jti"])
   end

   # Revoke the token by adding it to the blacklist
   def self.revoke_jwt(payload, _user)
     create!(jti: payload["jti"])
   end
end
