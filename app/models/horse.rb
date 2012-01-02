class Horse < WhiteHorseFarm::Model::Base
  attr_accessible :name, :description, :image
  validates :name, :presence => true

  has_many :action
  has_many :relationship
  #TODO has_many :ride, :compete, ...
  #TODO has_many :representative, :rider, :owner, ...
end
