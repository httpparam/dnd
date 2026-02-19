class CampaignMessagesController < ApplicationController
  before_action :require_login

  def create
    campaign = Campaign.find(params[:campaign_id])
    campaign.chat_messages.create!(user: current_user, body: message_params[:body])
    redirect_to root_path
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end

  def message_params
    params.require(:campaign_message).permit(:body)
  end
end
