class AddActionIdToHorse < ActiveRecord::Migration
  def change
    t.column :registration_id, :string
  end
end
