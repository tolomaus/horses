class Relationship < Base
  validates :user, :horse, :user_role, :presence => true
  #validates :user_id, :horse_id, :action_type_id, :numericality => { :only_integer => true }

  belongs_to :user
  belongs_to :horse
  belongs_to :user_role
end
