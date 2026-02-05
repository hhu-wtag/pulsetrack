class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :notifications, dependent: :destroy

  has_many :monitored_sites, through: :teams

  after_create :create_personal_team

  def has_edit_permission_in?(team)
    membership = memberships.find_by(team: team)

    membership&.admin? or membership&.editor?
  end

  def is_admin_of?(team)
    memberships.find_by(team: team)&.admin?
  end

  def is_member_of?(team)
    memberships.exists?(team: team)
  end

  private

  def create_personal_team
    team = teams.create!(name: "#{email.split('@').first}'s Team")

    memberships.find_by(team: team).update(role: :admin)
  end
end
