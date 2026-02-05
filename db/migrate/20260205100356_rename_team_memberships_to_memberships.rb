class RenameTeamMembershipsToMemberships < ActiveRecord::Migration[8.1]
  def change
    rename_table :team_memberships, :memberships
  end
end
