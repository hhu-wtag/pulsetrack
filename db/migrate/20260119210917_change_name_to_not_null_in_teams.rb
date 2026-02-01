class ChangeNameToNotNullInTeams < ActiveRecord::Migration[8.1]
  def change
    change_column_null :teams, :name, false
  end
end
