class ChangeOccurredFieldDataTypeOnAction < ActiveRecord::Migration
  def up
    remove_column :actions, :occurred_at
    add_column :actions, :occurred_at, :datetime, :null => false
  end

  def down
    remove_column :actions, :occurred_at
    add_column :actions, :occurred_at, :string, :null => false
  end
end
