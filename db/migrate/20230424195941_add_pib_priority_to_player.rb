class AddPibPriorityToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :pib_priority, :boolean
  end
end
