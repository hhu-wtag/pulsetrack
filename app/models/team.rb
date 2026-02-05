class Team < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :monitored_sites, dependent: :destroy

  accepts_nested_attributes_for :memberships

  validates :name, presence: true
end
