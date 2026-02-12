class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :full_name, presence: true, on: :update_profile
  validates :display_name, length: { maximum: 30 }

  # Generates a new login token that expires in 15 minutes
  def generate_login_token!
    self.login_token = SecureRandom.urlsafe_base64(32)
    self.login_token_expires_at = 15.minutes.from_now
    save!(validate: false) # Skip validation to allow token generation without password
    login_token
  end

  # Validates if the provided token is valid and not expired
  # Uses constant-time comparison to prevent timing attacks
  def valid_login_token?(token)
    return false if token.blank? || login_token.blank?
    return false if login_token_expires_at.past?

    ActiveSupport::SecurityUtils.secure_compare(login_token, token)
  end

  # Clears the login token after use (one-time use)
  def clear_login_token!
    update(login_token: nil, login_token_expires_at: nil)
  end

  # Finds or creates a user by email
  def self.find_or_create_by_email(email)
    find_or_create_by(email: email.downcase.strip) do |user|
      user.password = SecureRandom.hex(32) # Random password for has_secure_password
    end
  end
end
