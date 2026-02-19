class CampaignMailer < ApplicationMailer
  def match_notification
    @user = params[:user]
    @campaign = params[:campaign]
    @reason = params[:reason]

    mail to: @user.email, subject: "New campaign: #{@campaign.title}"
  end
end
