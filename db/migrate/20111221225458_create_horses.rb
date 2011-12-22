class CreateHorses < ActiveRecord::Migration
  def change
    create_table :horses do |t|
      t.string :name
      t.string :description
      t.string :image
      t.string :owner
      t.string :rider

      t.timestamps
    end
  end
end
