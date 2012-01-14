Factory.define :horse do |a|
  a.sequence (:name){|n| "Horse #{n}" }
  a.description {|x| "This is the description of #{x.name}" }
end

Factory.define :action do |r|
  r.sequence (:fb_action_id){|n| "FB#{n}" }
  r.user User.me.all.first
  r.action_type ActionType.find_by_name("register")
  r.occurred_at DateTime.now
end
#
#Factory.define :pcr_primitive, :class => Pcr do |p|
#  p.sequence (:code){|n| "PCR#{n}" }
#  p.summary {|x| "This is the summary of #{x.code}"}
#  p.description {|x| "This is the description of #{x.code}"}
#end
#
#Factory.define :pcr, :parent => :pcr_primitive do |p|
#  p.app App.first
#  p.release Release.first
#  p.status Status.first
#  p.severity Severity.first
#end
#
#Factory.define :pcr_view, :parent => :pcr_primitive do |p|
#  p.app_id 1
#  p.release_id 1
#  p.status_id 1
#  p.severity_id 1
#end
#
