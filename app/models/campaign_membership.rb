class CampaignMembership < ApplicationRecord
  belongs_to :campaign, counter_cache: :players_count
  belongs_to :user

  validates :user_id, uniqueness: { scope: :campaign_id }

  after_commit :broadcast_members_update

  private

  def broadcast_members_update
    campaign.broadcast_replace_later_to [campaign, :members],
      target: "campaign_members_#{campaign.id}",
      partial: "campaigns/members",
      locals: { campaign: campaign }
  end
end
