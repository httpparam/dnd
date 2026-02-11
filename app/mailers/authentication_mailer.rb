class AuthenticationMailer < ApplicationMailer
  def magic_link(user)
    @user = user
    @magic_link = login_url(token: @user.login_token)

    mail to: @user.email, subject: "Your Campaign Manager Login Link"
  end
end
