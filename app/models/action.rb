class Action < Base
  attr_accessible :horse_id, :fb_action_id, :user, :action_type, :occurred_at

  validates :fb_action_id, :user, :horse, :action_type, :occurred_at, :presence => true
  #validates :user_id, :horse_id, :action_type_id, :numericality => { :only_integer => true }
  validates :occurred_at, :date => true

  belongs_to :user
  belongs_to :horse, :inverse_of => :actions
  belongs_to :action_type
end
