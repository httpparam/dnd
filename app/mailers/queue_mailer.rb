class QueueMailer < ApplicationMailer
  def joined_queue
    @user = params[:user]
    mail to: @user.email, subject: "You are in the matching queue"
  end
end
