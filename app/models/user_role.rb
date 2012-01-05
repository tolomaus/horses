class UserRole < Base
  attr_accessible

  validates :name, :presence => true
end
