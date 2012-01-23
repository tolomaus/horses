class Horse < Base
  attr_accessible :name, :description, :image
  validates :name, :presence => true

  has_many :actions, :autosave => true, :inverse_of => :horse, :dependent => :destroy
  has_many :relationships, :autosave => true, :inverse_of => :horse, :dependent => :destroy

  scope :related_to_user, lambda{|user|
                            joins(:relationships)
                           .merge(Relationship.for_user user)
                           .uniq
                        }
  scope :with_related_users, includes(:relationships => [:user])

  #
  #def registration
  #  return actions.to_register.first
  #end
  #
  #def rides
  #  return actions.to_ride.all
  #end
  #
  #def competes
  #  return actions.to_compete.all
  #end
  #
  #def representative_rels
  #  return relationships.as_rider.all
  #end
  #
  #def rider_rels
  #  return relationships.as_rider.all
  #end
  #
  #def owner_rels
  #  return relationships.as_rider.all
  #end

  #has_one :registration, :autosave => true, :inverse_of => :horse, :dependent => :destroy,
  #         :class_name => "Action",
  #         :conditions => {:action_type_id => ActionType.register}
  #has_many :rides, :autosave => true, :inverse_of => :horse, :dependent => :destroy,
  #         :class_name => "Action",
  #         :conditions => {:action_type_id => ActionType.ride}
  #has_many :competes, :autosave => true, :inverse_of => :horse, :dependent => :destroy,
  #         :class_name => "Action",
  #         :conditions => {:action_type_id => ActionType.compete}
  #
  #has_many :rider_rels, :autosave => true, :inverse_of => :horse, :dependent => :destroy,
  #         :class_name => "Relationship",
  #         :conditions => {:user_role_id => UserRole.rider}
  #has_many :owner_rels, :autosave => true, :inverse_of => :horse, :dependent => :destroy,
  #         :class_name => "Relationship",
  #         :conditions => {:user_role_id => UserRole.owner}
  #has_many :representative_rels, :autosave => true, :inverse_of => :horse, :dependent => :destroy,
  #         :class_name => "Relationship",
  #         :conditions => {:user_role_id => UserRole.representative}
  #
  #validates_associated :actions #not necessary for has_many
  #validates_associated :relationships #not necessary for has_many
end
