class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :user, :null => false
      t.references :horse, :null => false
      t.references :user_role, :null => false

      t.timestamps
    end
    add_index :relationships, :user_id
    change_table :relationships do |t|
      t.foreign_key :users
      t.foreign_key :horses
      t.foreign_key :user_roles
    end
    add_index :relationships, :horse_id
    add_index :relationships, :user_role_id
    add_index(:relationships, [:user_id, :horse_id, :user_role_id], :unique => true)
  end
end
