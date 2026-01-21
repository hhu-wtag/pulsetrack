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

  def has_edit_permission_in?(team)
    membership = team_memberships.find_by(team: team)

    membership&.admin? or membership&.editor?
  end

  def is_admin_of?(team)
    team_memberships.find_by(team: team)&.admin?
  end

  private

  def create_personal_team
    team = teams.create!(name: "#{email.split('@').first}'s Team")

    team_memberships.find_by(team: team).update(role: :admin)
  end
end
