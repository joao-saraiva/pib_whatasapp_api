class RemoveStatusFromPlayerPerMatch < ActiveRecord::Migration[7.0]
  def change
    remove_column :player_per_matches, :status, :integer
  end
end
