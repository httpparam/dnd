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
    identity = profile["identity"] || {}

    user = User.find_or_initialize_by(hackclub_id: identity["id"].to_s)
    user.name = identity["name"] || profile["name"] || profile["display_name"]
    user.email = identity["email"] || profile["email"]
    user.avatar_url = identity["avatar"] || identity["avatar_url"] || profile["avatar"] || profile["avatar_url"]
    user.save!

    session[:user_id] = user.id
    session[:hackclub_token] = token

    redirect_to root_path
  rescue StandardError => e
    Rails.logger.error("Hack Club auth failed: #{e.class} #{e.message}")
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
