class Action < Base
  attr_accessible :horse_id, :fb_action_id, :user_id, :action_type, :occurred_at

  validates :fb_action_id, :user, :horse, :action_type, :occurred_at, :presence => true
  #validates :user_id, :horse_id, :action_type_id, :numericality => { :only_integer => true }
  validates :occurred_at, :date => true

  belongs_to :user
  belongs_to :horse
  belongs_to :action_type

  scope :to_register, where(:action_type_id => ActionType.register)
  scope :to_ride, where(:action_type_id => ActionType.ride)
  scope :to_compete, where(:action_type_id => ActionType.compete)

  scope :by_user, lambda{|user|where(:user => user)}
  scope :on_horse, lambda{|horse|where(:horse => horse)}
end
