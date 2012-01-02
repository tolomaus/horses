class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
