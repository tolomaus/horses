class ActionType < Base
  attr_accessible

  validates :name, :presence => true
end
