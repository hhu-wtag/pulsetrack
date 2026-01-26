class TransitionToTeams < ActiveRecord::Migration[8.1]
  def up
    # 1. Create a Team for every user and move their sites
    User.find_each do |user|
      # Create a personal team for the user
      team = Team.create!(name: "#{user.email.split('@').first}'s Team")

      # Make the user the Admin of this team
      TeamMembership.create!(user: user, team: team, role: :admin) # assuming enum { viewer: 0, admin: 1 }

      # Link all user's sites to this new team
      MonitoredSite.where(user_id: user.id).update_all(team_id: team.id)
    end

    # 2. Now that data is migrated, make team_id non-nullable
    change_column_null :monitored_sites, :team_id, false
  end

  def down
    # Logic to move team_id back to user_id if you ever need to rollback
    MonitoredSite.find_each do |site|
      owner = site.team.team_memberships.find_by(role: :admin)&.user
      site.update(user_id: owner.id) if owner
    end
  end
end
