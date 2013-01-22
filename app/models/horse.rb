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

  scope :with_related_users, includes(:relationships => [:user, :user_role])

  def self.sort_by_importance(horses, user)
    horses.each do |horse|
      horse.instance_eval do
        def tmp_importance
          instance_variable_get("@tmp_importance")
        end
        def tmp_importance=(val)
          instance_variable_set("@tmp_importance",val)
        end
      end
      horse.tmp_importance = 0
      horse.tmp_importance += 8 if horse.relationships.find{|r| r.user == user && r.user_role == UserRole.representative}!=nil
      horse.tmp_importance += 4 if horse.relationships.find{|r| r.user == user && r.user_role == UserRole.rider}!=nil
      horse.tmp_importance += 2 if horse.relationships.find{|r| r.user == user && r.user_role == UserRole.owner}!=nil
    end
    horses.sort_by do |horse|
      -horse.tmp_importance
    end
  end

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
