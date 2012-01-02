class UserRole < WhiteHorseFarm::Model::Base
  attr_accessible

  validates :name, :presence => true
end
