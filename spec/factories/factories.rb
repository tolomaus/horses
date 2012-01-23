Factory.define :user do |r|
  r.sequence (:fb_user_id){|n| "FB_ride_#{n}" }
end

Factory.define :horse do |r|
  r.sequence (:name){|n| "Horse #{n}" }
  r.description {|x| "This is the description of #{x.name}" }
end

Factory.define :action_base, :class => Action do |r|
  r.sequence (:fb_action_id){|n| "FB_ride_#{n}" }
  r.association :user, :factory => :user
  r.association :horse, :factory => :horse
  r.occurred_at Time.now
end

Factory.define :registration, :parent => :action_base do |r|
  r.action_type ActionType.register
end

Factory.define :ride, :parent => :action_base do |r|
  r.action_type ActionType.ride
end

Factory.define :compete, :parent => :action_base do |r|
  r.action_type ActionType.compete
end

Factory.define :relationship_base, :class => Relationship do |r|
  r.association :user, :factory => :user
  r.association :horse, :factory => :horse
end

Factory.define :rider_rel, :parent => :relationship_base do |r|
  r.user_role UserRole.rider
end

Factory.define :owner_rel, :parent => :relationship_base do |r|
  r.user_role UserRole.owner
end

Factory.define :representative_rel, :parent => :relationship_base do |r|
  r.user_role UserRole.representative
end
