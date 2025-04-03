class Team < ApplicationRecord
  has_many :incidents, foreign_key: "team_id", primary_key: "team_id"

  validates :team_id, presence: true, uniqueness: true
  validates :access_token, presence: true
end
