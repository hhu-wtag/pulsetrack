class AddNextCheckAtToMonitoredSites < ActiveRecord::Migration[8.0]
  def change
    add_column :monitored_sites, :next_check_at, :datetime
    change_column_default :monitored_sites, :next_check_at, -> { 'CURRENT_TIMESTAMP' }
    add_index :monitored_sites, :next_check_at
  end
end
