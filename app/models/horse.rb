class Horse < ActiveRecord::Base
  attr_accessible :name, :description, :image, :owner, :rider
  validates :name, :presence => true
  validates :description, :presence => true
  validates :image, :presence => true
  validates :owner, :presence => true
  validates :rider, :presence => true
end
