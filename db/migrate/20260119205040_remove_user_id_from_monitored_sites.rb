class RemoveUserIdFromMonitoredSites < ActiveRecord::Migration[8.1]
  def change
    remove_reference :monitored_sites, :user, null: false, foreign_key: true
  end
end
