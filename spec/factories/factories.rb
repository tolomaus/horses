FactoryGirl.define do
  factory :user do |r|
    r.sequence (:fb_user_id){|n| "FB_ride_#{n}" }
  end

  factory :horse do |r|
    r.sequence (:name){|n| "Horse #{n}" }
    r.description {|x| "This is the description of #{x.name}" }
  end

  factory :action_base, :class => Action do |r|
    r.sequence (:fb_action_id){|n| "FB_ride_#{n}" }
    r.association :user, :factory => :user
    r.association :horse, :factory => :horse
    r.occurred_at Time.now
  end

  factory :registration, :parent => :action_base do |r|
    r.action_type ActionType.register
  end

  factory :ride, :parent => :action_base do |r|
    r.action_type ActionType.ride
  end

  factory :compete, :parent => :action_base do |r|
    r.action_type ActionType.compete
  end

  factory :relationship_base, :class => Relationship do |r|
    r.association :user, :factory => :user
    r.association :horse, :factory => :horse
  end

  factory :rider_rel, :parent => :relationship_base do |r|
    r.user_role UserRole.rider
  end

  factory :owner_rel, :parent => :relationship_base do |r|
    r.user_role UserRole.owner
  end

  factory :representative_rel, :parent => :relationship_base do |r|
    r.user_role UserRole.representative
  end
end