class SessionsController < ApplicationController
  def new
    # Login form is rendered on the home page
  end

  def create
    email = params[:email]

    if email.blank?
      redirect_to root_path, alert: "Please enter your email address."
      return
    end

    user = User.find_or_create_by_email(email)
    user.generate_login_token!
    AuthenticationMailer.magic_link(user).deliver_now

    redirect_to root_path, notice: "Check your email for a magic link to sign in!"
  end

  def show
    token = params[:token]

    if token.blank?
      redirect_to root_path, alert: "Invalid login link."
      return
    end

    user = User.find_by(login_token: token)

    if user&.valid_login_token?(token)
      user.clear_login_token!
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Welcome back, Adventurer!"
    else
      redirect_to root_path, alert: "Invalid or expired login link. Please request a new one."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, status: :see_other
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have been logged out. Until next time!"
  end
end
