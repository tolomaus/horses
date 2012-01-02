class EnforceEvenMoreRequiredFields < ActiveRecord::Migration
  def up
    change_column :actions, :occurred, :string, :null => false
    change_column :horses, :created_at, :datetime, :null => false
    change_column :horses, :updated_at, :datetime, :null => false
  end

  def down
    change_column :actions, :occurred, :datetime, :null => true
    change_column :horses, :created_at, :datetime, :null => true
    change_column :horses, :updated_at, :datetime, :null => true
  end
end
