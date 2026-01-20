class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :notifications, dependent: :destroy

  has_many :monitored_sites, through: :teams

  after_create :create_personal_team

  private

  def create_personal_team
    team = teams.create!(name: "#{email.split('@').first}'s Team")

    team_memberships.find_by(team: team).update(role: :admin)
  end
end
