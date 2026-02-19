class CampaignsController < ApplicationController
  before_action :require_login

  def show
    @campaign = Campaign.includes(:dm, :players, :chat_messages, join_requests: :user).find_by(id: params[:id])
    return if @campaign

    redirect_to root_path, alert: "Campaign not found.", status: :see_other
  end

  def create
    Rails.logger.info("current_user class: #{current_user.class}")
    Rails.logger.info("current_user id: #{current_user.id}")
    Rails.logger.info("session[:user_id]: #{session[:user_id]}")

    unless current_user.is_a?(User)
      reset_session
      redirect_to root_path, alert: "Session error. Please log in again."
      return
    end

    campaign = Campaign.new(campaign_params.merge(dm_id: current_user.id))

    if campaign.save
      redirect_to root_path, notice: "Campaign created!"
    else
      Rails.logger.error("Campaign creation failed: #{campaign.errors.full_messages.to_sentence}")
      Rails.logger.error("Campaign params: #{campaign_params.inspect}")
      redirect_to root_path, alert: "Failed: #{campaign.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    campaign = Campaign.find(params[:id])
    unless campaign.dm_id == current_user.id
      redirect_to campaign_path(campaign), alert: "Only the DM can delete this campaign.", status: :see_other
      return
    end

    campaign.destroy
    redirect_to root_path, notice: "Campaign deleted.", status: :see_other
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end

  def campaign_params
    params.require(:campaign).permit(:title, :status, :atmosphere, :start_time, :players_count, needs: [])
  end
end
