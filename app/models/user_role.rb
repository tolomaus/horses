class UserRole < Base
  attr_accessible :name

  validates :name, :presence => true

  def self.rider
    self.find_by_name "rider"
  end
  def self.owner
    self.find_by_name "owner"
  end
  def self.representative
    self.find_by_name "representative"
  end
end
