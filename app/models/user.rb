class User < Base
  attr_accessible :fb_user_id

  validates :fb_user_id, :presence => true

  def self.me
    self.find_by_fb_user_id "1185998828"
  end
  def self.prutse
    self.find_by_fb_user_id "1697986600"
  end
end
