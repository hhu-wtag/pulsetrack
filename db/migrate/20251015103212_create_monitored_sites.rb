class CreateMonitoredSites < ActiveRecord::Migration[8.0]
  def change
    create_table :monitored_sites do |t|
      t.references :user, null: false, foreign_key: true

      t.string :name, null: false
      t.string :url, null: false
      t.integer :check_frequency_seconds, default: 300
      t.integer :last_status, default: 0

      t.timestamps
    end
  end
end
