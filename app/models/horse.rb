class Horse < Base
  attr_accessible :name, :description, :image
  validates :name, :presence => true

  has_many :actions, :autosave => true, :inverse_of => :horse
  has_many :rides, :autosave => true, :inverse_of => :horse,
           :class_name => "Action",
           :conditions => {:action_type_id => ActionType.ride}
  has_one :registration, :autosave => true, :inverse_of => :horse,
           :class_name => "Action",
           :conditions => {:action_type_id => ActionType.register}

  has_many :relationships, :autosave => true, :inverse_of => :horse
  has_many :users, :through => :relationships, :uniq => true
  has_many :riders, :through => :relationships,
           :source => :user,
           :conditions => {"relationships.user_role_id" => UserRole.rider}

  #validates_associated :actions #not necessary for has_many
  #validates_associated :relationships #not necessary for has_many
end
