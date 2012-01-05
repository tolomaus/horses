class Horse < Base
  attr_accessible :name, :description, :image
  validates :name, :presence => true

  has_many :actions
  has_many :relationships
  #TODO has_many :rides, :competes, ...
  #TODO has_many :representatives, :riders, :owners, ...
end
