class Horse < Base
  attr_accessible :name, :description, :image
  validates :name, :presence => true

  has_many :actions, :inverse_of => :horse
  has_many :relationships
  #TODO has_many :rides, :competes, ...
  #TODO has_many :representatives, :riders, :owners, ...

  #validates_associated :actions #not necessary for has_many
  #validates_associated :relationships #not necessary for has_many
end
