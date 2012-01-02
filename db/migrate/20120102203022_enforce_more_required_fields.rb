class EnforceMoreRequiredFields < ActiveRecord::Migration
  def up
    change_column :actions, :fb_action_id, :string, :null => false
    remove_column :actions, :name
    remove_column :horses, :owner
    remove_column :horses, :rider
    change_column :horses, :name, :string, :null => false
    change_column :users, :fb_user_id, :string, :null => false
    add_index :users, :fb_user_id, :unique => true
  end

  def down
    change_column :actions, :fb_action_id, :integer, :null => false
    add_column :actions, :name, :string
    add_column :horses, :owner, :integer
    add_column :horses, :rider, :integer
    change_column :horses, :name, :string, :null => true
    change_column :users, :fb_user_id, :string, :null => true
    remove_index :users, :fb_user_id
  end
end
