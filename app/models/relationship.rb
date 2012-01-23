class Relationship < Base
  validates :user, :horse, :user_role, :presence => true
  #validates :user_id, :horse_id, :action_type_id, :numericality => { :only_integer => true }

  belongs_to :user
  belongs_to :horse
  belongs_to :user_role

  scope :as_representative, where(:user_role_id => UserRole.representative)
  scope :as_rider, where(:user_role_id => UserRole.rider)
  scope :as_owner, where(:user_role_id => UserRole.owner)

  scope :for_user, lambda{|user|where(:user_id => user)}
  scope :for_horse, lambda{|horse|where(:horse_id => horse)}

  scope :select_horses, joins(:horse).uniq
end
