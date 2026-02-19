class Campaign < ApplicationRecord
  belongs_to :dm, class_name: "User", optional: true

  validates :title, presence: true

  broadcasts_to :campaigns, inserts_by: :prepend
end
