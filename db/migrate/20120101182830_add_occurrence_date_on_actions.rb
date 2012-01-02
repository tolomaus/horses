class AddOccurrenceDateOnActions < ActiveRecord::Migration
  def change
    change_table :actions do |t|
      t.column :occurred , :datetime
    end
  end
end
