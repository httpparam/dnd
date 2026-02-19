class CampaignsController < ApplicationController
  before_action :require_login

  def create
    Rails.logger.info("current_user class: #{current_user.class}")
    Rails.logger.info("current_user id: #{current_user.id}")
    Rails.logger.info("session[:user_id]: #{session[:user_id]}")

    campaign = current_user.campaigns.build(campaign_params)

    if campaign.save
      redirect_to root_path, notice: "Campaign created!"
    else
      Rails.logger.error("Campaign creation failed: #{campaign.errors.full_messages.to_sentence}")
      Rails.logger.error("Campaign params: #{campaign_params.inspect}")
      redirect_to root_path, alert: "Failed: #{campaign.errors.full_messages.to_sentence}"
    end
  end

  def join
    campaign = Campaign.find(params[:id])
    campaign.memberships.create!(user: current_user)
    redirect_to root_path, notice: "Joined campaign."
  end

  def leave
    campaign = Campaign.find(params[:id])
    campaign.memberships.where(user: current_user).destroy_all
    redirect_to root_path, notice: "Left campaign."
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end

  def campaign_params
    params.require(:campaign).permit(:title, :status, :atmosphere, :start_time, :players_count, needs: [])
  end
end
