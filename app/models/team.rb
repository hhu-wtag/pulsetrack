class Team < ApplicationRecord
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :monitored_sites, dependent: :destroy

  validates :name, presence: true
end
