class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.text :message, null: false
      t.datetime :read_at, index: true
      t.timestamps
    end
  end
end
