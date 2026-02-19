class CampaignJoinRequestsController < ApplicationController
  before_action :require_login
  before_action :set_campaign
  before_action :require_dm!, only: %i[approve deny]

  def create
    if @campaign.member?(current_user)
      redirect_to campaign_path(@campaign), alert: "You are already in this campaign."
      return
    end

    @campaign.join_requests.create!(user: current_user, status: "pending")
    redirect_to campaign_path(@campaign), notice: "Request sent."
  end

  def approve
    request = @campaign.join_requests.find(params[:id])
    request.update!(status: "approved")
    @campaign.memberships.create!(user: request.user)
    redirect_to campaign_path(@campaign), notice: "Request approved."
  end

  def deny
    request = @campaign.join_requests.find(params[:id])
    request.update!(status: "denied")
    redirect_to campaign_path(@campaign), notice: "Request denied."
  end

  def destroy
    @campaign.join_requests.where(user: current_user).destroy_all
    redirect_to campaign_path(@campaign), notice: "Request withdrawn."
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def require_dm!
    return if @campaign.dm_id == current_user.id

    redirect_to campaign_path(@campaign), alert: "Only the DM can do that."
  end
end
