class Campaign < ApplicationRecord
  belongs_to :dm, class_name: "User", optional: true
  has_many :memberships, class_name: "CampaignMembership", dependent: :destroy
  has_many :players, through: :memberships, source: :user
  has_many :chat_messages, class_name: "CampaignMessage", dependent: :destroy
  has_many :join_requests, class_name: "CampaignJoinRequest", dependent: :destroy

  validates :title, presence: true

  broadcasts_to :campaigns, inserts_by: :prepend

  after_commit :notify_users_for_campaign, on: %i[create update]

  def member?(user)
    return false if user.nil?
    return true if dm_id == user.id

    players.exists?(user.id)
  end

  private

  def notify_users_for_campaign
    return unless created_or_live?

    User.email_opted_in.find_each do |user|
      next if user == dm

      reason = if user.matches_campaign?(self)
        "match"
      elsif live_notification?
        "live"
      end

      next if reason.nil?

      CampaignMailer.with(user: user, campaign: self, reason: reason)
        .match_notification
        .deliver_now
    end
  end

  def created_or_live?
    previous_changes.key?("id") || live_notification?
  end

  def live_notification?
    status == "Accepting" && saved_change_to_status?
  end
end
