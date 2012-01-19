class ActionType < Base
  attr_accessible :name

  validates :name, :presence => true

  def self.register
    self.find_by_name "register"
  end
  def self.ride
    self.find_by_name "ride"
  end
  def self.compete
    self.find_by_name "compete"
  end
end
