class User < Base
  attr_accessible :fb_user_id

  validates :fb_user_id, :presence => true

  has_many :actions, :autosave => true, :inverse_of => :user, :dependent => :destroy
  has_many :relationships, :autosave => true, :inverse_of => :user, :dependent => :destroy

  def self.me
    self.find_by_fb_user_id "1185998828"
  end
  def self.prutse
    self.find_by_fb_user_id "1697986600"
  end
  #has_one :registration, :autosave => true, :inverse_of => :user, :dependent => :delete,
  #         :class_name => "Action",
  #         :conditions => {:action_type_id => ActionType.register}
  #has_many :rides, :autosave => true, :inverse_of => :user, :dependent => :delete_all,
  #         :class_name => "Action",
  #         :conditions => {:action_type_id => ActionType.ride}
  #has_many :competes, :autosave => true, :inverse_of => :user, :dependent => :delete_all,
  #         :class_name => "Action",
  #         :conditions => {:action_type_id => ActionType.compete}
  #
  #has_many :rider_rels, :autosave => true, :inverse_of => :user, :include => :horse, :dependent => :destroy,
  #         :class_name => "Relationship",
  #         :conditions => {:user_role_id => UserRole.rider}
  #has_many :owner_rels, :autosave => true, :inverse_of => :user, :include => :horse, :dependent => :destroy,
  #         :class_name => "Relationship",
  #         :conditions => {:user_role_id => UserRole.owner}
  #has_many :representative_rels, :autosave => true, :inverse_of => :user, :include => :horse, :dependent => :destroy,
  #         :class_name => "Relationship",
  #         :conditions => {:user_role_id => UserRole.representative}
end
