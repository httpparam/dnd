require "net/http"
require "uri"

class SessionsController < ApplicationController
  AUTH_BASE = "https://auth.hackclub.com"

  def new
    state = SecureRandom.hex(16)
    session[:oauth_state] = state

    redirect_to authorize_url(state), allow_other_host: true
  end

  def callback
    if params[:state].blank? || params[:state] != session.delete(:oauth_state)
      redirect_to root_path, alert: "OAuth state mismatch. Please try again."
      return
    end

    if params[:code].blank?
      redirect_to root_path, alert: "Missing OAuth code. Please try again."
      return
    end

    token = exchange_code_for_token(params[:code])
    profile = fetch_user_profile(token)

    Rails.logger.info("Hack Club Profile response: #{profile.inspect}")

    # The profile can have different structures:
    # 1. {identity: {id, primary_email, first_name, last_name, slack_id}}
    # 2. {id, email, name}
    user_data = profile["identity"] || profile
    hackclub_id = (user_data["id"] || user_data["slack_id"] || profile["slack_id"]).to_s

    Rails.logger.info("Extracted: hackclub_id=#{hackclub_id}, user_data keys=#{user_data.keys.inspect}")

    user = User.find_or_initialize_by(hackclub_id: hackclub_id)

    # Try multiple possible fields for name (Hack Club uses first_name + last_name)
    user.name ||= if user_data["first_name"] || user_data["last_name"]
                    [user_data["first_name"], user_data["last_name"]].compact.join(" ")
                  else
                    user_data["name"] ||
                    user_data["username"] ||
                    user_data["display_name"] ||
                    profile["name"] ||
                    profile["username"] ||
                    profile["display_name"]
                  end

    # Try multiple possible fields for email (Hack Club uses primary_email)
    user.email ||= user_data["primary_email"] ||
                   user_data["email"] ||
                   profile["primary_email"] ||
                   profile["email"]

    # Try multiple possible fields for avatar
    user.avatar_url ||= user_data["avatar"] ||
                        user_data["avatar_url"] ||
                        user_data["profile_picture"] ||
                        profile["avatar"] ||
                        profile["avatar_url"] ||
                        profile["profile_picture"]

    Rails.logger.info("Saving user: hackclub_id=#{user.hackclub_id}, name=#{user.name.inspect}, email=#{user.email.inspect}")

    user.save!

    session[:user_id] = user.id
    session[:hackclub_token] = token

    redirect_to root_path
  rescue StandardError => e
    Rails.logger.error("Hack Club auth failed: #{e.class} #{e.message}")
    Rails.logger.error(e.backtrace.first(10).join("\n"))
    redirect_to root_path, alert: "Login failed. Please try again."
  end

  def destroy
    session.delete(:user_id)
    session.delete(:hackclub_token)
    redirect_to root_path
  end

  private

  def authorize_url(state)
    params = {
      response_type: "code",
      client_id: ENV.fetch("HACKCLUB_CLIENT_ID"),
      redirect_uri: ENV.fetch("HACKCLUB_REDIRECT_URI"),
      scope: ENV.fetch("HACKCLUB_SCOPES", "openid email profile"),
      state: state
    }

    uri = URI.join(AUTH_BASE, "/oauth/authorize")
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  def exchange_code_for_token(code)
    uri = URI.join(AUTH_BASE, "/oauth/token")
    response = Net::HTTP.post_form(uri, {
      grant_type: "authorization_code",
      code: code,
      redirect_uri: ENV.fetch("HACKCLUB_REDIRECT_URI"),
      client_id: ENV.fetch("HACKCLUB_CLIENT_ID"),
      client_secret: ENV.fetch("HACKCLUB_CLIENT_SECRET")
    })

    unless response.is_a?(Net::HTTPSuccess)
      raise "Token exchange failed: #{response.code} #{response.body}"
    end

    payload = JSON.parse(response.body)
    payload.fetch("access_token")
  end

  def fetch_user_profile(token)
    uri = URI.join(AUTH_BASE, "/api/v1/me")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "Profile fetch failed: #{response.code} #{response.body}"
    end

    JSON.parse(response.body)
  end
end
