class AddObjectIdToHorse < ActiveRecord::Migration
  def change
    change_table :horses do |t|
      t.column :object_id, :string
    end
  end
end
