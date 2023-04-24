class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :number
      t.string :name
      t.integer :player_friend_id

      t.timestamps
    end
  end
end
