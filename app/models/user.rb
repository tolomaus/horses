class User < Base
  attr_accessible

  validates :fb_user_id, :presence => true
end
