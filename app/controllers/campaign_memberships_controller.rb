class CampaignMembershipsController < ApplicationController
  before_action :require_login
  before_action :set_campaign

  def destroy
    membership = @campaign.memberships.find(params[:id])

    if membership.user_id == current_user.id || @campaign.dm_id == current_user.id
      membership.destroy
      redirect_to campaign_path(@campaign), notice: "Member removed."
    else
      redirect_to campaign_path(@campaign), alert: "Not allowed."
    end
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
