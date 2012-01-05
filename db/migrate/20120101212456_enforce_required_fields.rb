class EnforceRequiredFields < ActiveRecord::Migration
  def up
    remove_index(:actions, [:user_id, :horse_id, :action_type_id])
    add_index(:actions, [:user_id, :horse_id, :action_type_id], { :name => "index_actions_ud_hid_atid", :unique => true })
    change_column :action_types, :name, :string, :null => false
    add_index :action_types, :name, :unique => true
    change_column :actions, :name, :string, :null => false
    add_index :actions, :name, :unique => true
    change_column :actions, :fb_action_id, :string, :null => false
    change_column :actions, :user_id, :integer, :null => false
    change_column :actions, :horse_id, :integer, :null => false
    change_column :actions, :action_type_id, :integer, :null => false
  end

  def down
    change_column :action_types, :name, :string, :null => true
    remove_index :action_types, :name
    change_column :actions, :name, :string, :null => true
    remove_index :actions, :name
    change_column :actions, :fb_action_id, :string, :null => true
    change_column :actions, :user_id, :integer, :null => true
    change_column :actions, :horse_id, :integer, :null => true
    change_column :actions, :action_type_id, :integer, :null => true
  end
end
