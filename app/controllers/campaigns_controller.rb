class CampaignsController < ApplicationController
  before_action :require_login

  def create
    campaign = current_user.campaigns.build(campaign_params)
    if campaign.save
      redirect_to root_path, notice: "Campaign created."
    else
      redirect_to root_path, alert: campaign.errors.full_messages.to_sentence
    end
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end

  def campaign_params
    params.require(:campaign).permit(:title, :status, :atmosphere, :start_time, :players_count, needs: [])
  end
end
