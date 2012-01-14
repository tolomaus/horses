class User < Base
  attr_accessible :fb_user_id

  validates :fb_user_id, :presence => true

  scope :me, where(:fb_user_id => "1185998828")
  scope :prutse, where(:fb_user_id => "1697986600")
end
