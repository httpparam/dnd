class CampaignMessage < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  validates :body, presence: true, length: { maximum: 500 }

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_later_to [campaign, :chat],
      target: "campaign_chat_#{campaign.id}",
      partial: "campaigns/message",
      locals: { message: self }
  end
end
