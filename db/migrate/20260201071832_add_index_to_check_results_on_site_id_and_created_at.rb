class AddIndexToCheckResultsOnSiteIdAndCreatedAt < ActiveRecord::Migration[8.1]
  def change
    add_index :check_results, [ :monitored_site_id, :created_at ]
  end
end
