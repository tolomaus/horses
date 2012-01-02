class RemoveRegistrationIdOnHorses < ActiveRecord::Migration
  def change
    change_table :horses do |t|
      t.remove :fb_registration_id
    end
  end
end
