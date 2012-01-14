class RemoveUniqueIndexOnAction < ActiveRecord::Migration
  def up
    remove_index(:actions, { :name => "index_actions_ud_hid_atid"})
  end

  def down
    add_index(:actions, [:user_id, :horse_id, :action_type_id], { :name => "index_actions_ud_hid_atid", :unique => true })
  end
end
