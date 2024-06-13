module AuthHelper
    require 'jwt'
  
    def generate_auth_token
        payload = { timestamp: Time.now.to_i }
        secret = Rails.application.secrets.secret_key_base || 'your_secret_key_here'
        JWT.encode(payload, secret, 'HS256')
    end
end
