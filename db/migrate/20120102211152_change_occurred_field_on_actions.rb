class ChangeOccurredFieldOnActions < ActiveRecord::Migration
  def change
    rename_column :actions, :occurred, :occurred_at
  end
end
