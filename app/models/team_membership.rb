class TeamMembership < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum :role, { viewer: 0, editor: 1, admin: 2 }, default: :viewer
end
