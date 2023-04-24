class CreatePlayerPerMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :player_per_matches do |t|
      t.integer :player_id
      t.integer :match_id
      t.integer :status
      t.integer :position

      t.timestamps
    end
  end
end
