class CreateCheckResults < ActiveRecord::Migration[8.0]
  def change
    create_table :check_results do |t|
      t.references :monitored_site, null: false, foreign_key: true
      t.integer :status
      t.integer :http_status_code
      t.integer :response_time_ms
      t.text :error_message

      t.timestamps

      t.index :created_at
    end
  end
end
