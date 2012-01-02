class RenameUserIdOnHorses < ActiveRecord::Migration
  def up
    Horse.delete_all
    change_table :horses do |t|
      t.column :user_id, :integer
      t.remove :fb_user_id
    end
  end

  def down
    change_table :horses do |t|
      t.column :fb_user_id, :string
      t.remove :user_id
    end
  end

end
