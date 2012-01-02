class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.string :fb_action_id
      t.references :user
      t.references :horse
      t.references :action_type

      t.timestamps
    end
    add_index :actions, :user_id
    add_index :actions, :horse_id
    add_index :actions, :action_type_id
  end
end
