class ChangeOccurredFieldDataTypeOnAction < ActiveRecord::Migration
  def up
    change_column :actions, :occurred_at, :datetime
  end

  def down
    change_column :actions, :occurred_at, :string
  end
end
