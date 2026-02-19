class CampaignJoinRequest < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  STATUSES = %w[pending approved denied].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: { scope: :campaign_id }

  scope :pending, -> { where(status: "pending") }
end
