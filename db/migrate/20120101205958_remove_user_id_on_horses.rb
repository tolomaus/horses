class RemoveUserIdOnHorses < ActiveRecord::Migration
  def change
    change_table :horses do |t|
      t.remove :user_id
    end
  end
end
