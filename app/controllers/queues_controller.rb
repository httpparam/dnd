class QueuesController < ApplicationController
  before_action :require_login

  def create
    current_user.update!(queued_for_matching: true, queued_at: Time.current)
    if current_user.email_notifications? && current_user.email.present?
      QueueMailer.with(user: current_user).joined_queue.deliver_now
    end
    redirect_to root_path, notice: "You are in the queue."
  end

  def destroy
    current_user.update!(queued_for_matching: false, queued_at: nil)
    redirect_to root_path, notice: "You left the queue."
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end
end
