class ActionType < WhiteHorseFarm::Model::Base
  attr_accessible

  validates :name, :presence => true
end
