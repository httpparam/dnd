module CampaignsHelper
  def campaign_dm_name(campaign)
    campaign.dm&.name.presence || "Pending..."
  end

  def campaign_status_badge_classes(campaign)
    if campaign.status == "Accepting"
      "border-emerald-500 text-emerald-500"
    else
      "border-amber-500 text-amber-500"
    end
  end

  def dm_for_campaign?(campaign, user)
    campaign.dm_id == user&.id
  end

  def campaign_join_request_for(campaign, user)
    return if user.nil?

    campaign.join_requests.find_by(user: user)
  end

  def campaign_membership_for(campaign, user)
    return if user.nil?

    campaign.memberships.find_by(user: user)
  end

  def campaign_join_state(campaign, user)
    return :member if campaign.member?(user)

    request = campaign_join_request_for(campaign, user)
    return request.status.to_sym if request

    :none
  end

  def show_leave_campaign_button?(campaign, user)
    campaign.member?(user) && !dm_for_campaign?(campaign, user)
  end

  def pending_join_requests_for(campaign)
    campaign.join_requests.pending.includes(:user)
  end

  def campaign_membership_map(campaign)
    campaign.memberships.index_by(&:user_id)
  end

  def fallback_player_name(user)
    user.name.presence || "Adventurer"
  end
end
