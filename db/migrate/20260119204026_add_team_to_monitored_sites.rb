class AddTeamToMonitoredSites < ActiveRecord::Migration[8.1]
  def change
    add_reference :monitored_sites, :team, null: true, foreign_key: true
  end
end
