class AddActionIdToHorse < ActiveRecord::Migration
  def change
    change_table :horses do |t|
      t.column :registration_id, :string
    end
  end
end
