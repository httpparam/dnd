class HackclubAuthController < ApplicationController
  require 'http'

  AUTH_URL = 'https://auth.hackclub.com/oauth/authorize'
  TOKEN_URL = 'https://auth.hackclub.com/oauth/token'
  API_URL = 'https://auth.hackclub.com/api/v1/me'
  REDIRECT_URI = 'http://localhost:3000/oauth/callback'

  def authorize
    state = SecureRandom.urlsafe_base64(32)
    session[:oauth_state] = state

    redirect_to "#{AUTH_URL}?#{{
      client_id: ENV.fetch('HACKCLUB_CLIENT_ID'),
      redirect_uri: REDIRECT_URI,
      response_type: 'code',
      scope: 'openid profile email name slack_id',
      state: state
    }.to_query}", allow_other_host: true
  end

  def callback
    code = params[:code]
    state = params[:state]
    error = params[:error]

    if error
      redirect_to root_path, alert: 'Authentication failed or was cancelled.'
      return
    end

    if state != session[:oauth_state]
      redirect_to root_path, alert: 'Invalid OAuth state.'
      return
    end

    # Exchange code for access token
    token_response = HTTP.post(TOKEN_URL, form: {
      client_id: ENV.fetch('HACKCLUB_CLIENT_ID'),
      client_secret: ENV.fetch('HACKCLUB_CLIENT_SECRET'),
      redirect_uri: REDIRECT_URI,
      code: code,
      grant_type: 'authorization_code'
    })

    unless token_response.status == 200
      redirect_to root_path, alert: 'Failed to exchange authorization code.'
      return
    end

    token_data = JSON.parse(token_response.body)
    access_token = token_data['access_token']

    # Get user info from Hack Club API
    user_response = HTTP.auth("Bearer #{access_token}").get(API_URL)

    unless user_response.status == 200
      redirect_to root_path, alert: 'Failed to fetch user info.'
      return
    end

    user_info = JSON.parse(user_response.body)

    identity = user_info.dig('identity')
    email = identity&.dig('primary_email')
    first_name = identity&.dig('first_name')
    last_name = identity&.dig('last_name')
    slack_id = identity&.dig('slack_id')

    if email.blank?
      redirect_to root_path, alert: 'No email found in Hack Club profile.'
      return
    end

    full_name = "#{first_name} #{last_name}"

    user = User.find_or_create_by_email(email)
    user.update_from_hackclub!(full_name: full_name, slack_id: slack_id)

    session[:user_id] = user.id

    redirect_to dashboard_path, notice: 'Welcome back, Adventurer!'
  end
end


