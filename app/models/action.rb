class Action < WhiteHorseFarm::Model::Base
  attr_accessible

  validates :fb_action_id, :user_id, :horse_id, :action_type_id, :occurred_at, :presence => true
  validates :user_id, :horse_id, :action_type_id, :numericality => { :only_integer => true }
  validates :occurred_at, :date => true

  belongs_to :user
  belongs_to :horse
  belongs_to :action_type
end
