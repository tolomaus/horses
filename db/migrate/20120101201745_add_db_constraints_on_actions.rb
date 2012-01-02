class AddDbConstraintsOnActions < ActiveRecord::Migration
  def up
    change_table :actions do |t|
      t.foreign_key :users
      t.foreign_key :horses
      t.foreign_key :action_types
    end
    add_index(:actions, [:user_id, :horse_id, :action_type_id], :unique => true)
  end

  def down
    change_table :actions do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :horses
      t.remove_foreign_key :action_types
    end
    remove_index(:actions, [:user_id, :horse_id, :action_type_id])
  end
end
