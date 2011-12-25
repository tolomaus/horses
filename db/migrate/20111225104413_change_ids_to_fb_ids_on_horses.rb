class ChangeIdsToFbIdsOnHorses < ActiveRecord::Migration
  def change
    change_table :horses do |t|
      t.rename :object_id, :fb_object_id
      t.rename :registration_id, :fb_registration_id
      t.column :fb_user_id, :string
    end
  end

end
