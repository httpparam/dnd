class User < ApplicationRecord
  has_many :campaigns, foreign_key: :dm_id, dependent: :nullify

  validates :hackclub_id, presence: true, uniqueness: true

  after_update_commit :broadcast_footer_update
  after_update_commit :broadcast_suggestions_update

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

  private

  def broadcast_footer_update
    broadcast_replace_later_to [self, :footer],
      target: ApplicationController.helpers.dom_id(self, :footer),
      partial: "users/footer",
      locals: { user: self }
  end

  def broadcast_suggestions_update
    broadcast_replace_later_to [self, :suggestions],
      target: "matching_suggestions",
      partial: "home/suggestions",
      locals: { suggested_users: suggested_users(limit: 6).to_a }
  end
end
