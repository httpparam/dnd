class User < ApplicationRecord
  has_many :campaigns, foreign_key: :dm_id, dependent: :nullify

  validates :hackclub_id, presence: true, uniqueness: true

  after_update_commit :broadcast_footer_update
  after_commit :broadcast_suggestions_update, on: %i[create update destroy]
  after_commit :broadcast_queue_update, on: %i[create update]

  scope :email_opted_in, -> { where(email_notifications: true).where.not(email: [nil, ""]) }

  def suggested_users(limit: 6)
    candidates = User.where.not(id: id)
    return candidates.limit(limit).to_a if styles.empty? && atmospheres.empty?

    scored = candidates.map do |candidate|
      score = (candidate.styles & styles).size + (candidate.atmospheres & atmospheres).size
      [candidate, score]
    end

    scored.sort_by { |(_, score)| -score }.map(&:first).first(limit)
  end

  def prefs_complete?
    experience_level.present? &&
      roles.any? &&
      styles.any? &&
      atmospheres.any? &&
      availability.present?
  end

  def matches_campaign?(campaign)
    return false if campaign.nil?

    atmosphere_match = atmospheres.empty? ||
      (campaign.atmosphere.present? && atmospheres.include?(campaign.atmosphere))

    role_match = true
    if campaign.needs.present?
      role_match = campaign.needs.any? { |need| role_matches_need?(need) }
    end

    atmosphere_match && role_match
  end

  private

  def broadcast_queue_update
    broadcast_replace_later_to [self, :queue],
      target: "queue_status",
      partial: "home/queue",
      locals: { user: self }
  end

  def broadcast_footer_update
    broadcast_replace_later_to [self, :footer],
      target: ApplicationController.helpers.dom_id(self, :footer),
      partial: "users/footer",
      locals: { user: self }
  end

  def broadcast_suggestions_update
    User.find_each do |viewer|
      viewer.broadcast_replace_later_to [viewer, :suggestions],
        target: "matching_suggestions",
        partial: "home/suggestions",
        locals: { suggested_users: viewer.suggested_users(limit: 6).to_a }
    end
  end

  def role_matches_need?(need)
    return true if roles.empty?

    case need
    when "DM"
      roles.include?("Dungeon Master")
    when "Supporter"
      roles.include?("Supporter / Helper")
    else
      roles.include?("Player")
    end
  end
end
