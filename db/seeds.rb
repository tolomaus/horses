# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
action_type = ActionType.find_or_create_by_name(:name => "register")
action_type = ActionType.find_or_create_by_name(:name => "ride")
action_type = ActionType.find_or_create_by_name(:name => "compete")

user_role = UserRole.find_or_create_by_name(:name => "representative")
user_role = UserRole.find_or_create_by_name(:name => "rider")
user_role = UserRole.find_or_create_by_name(:name => "owner")
user_role = UserRole.find_or_create_by_name(:name => "groom")
user_role = UserRole.find_or_create_by_name(:name => "trainer")
user_role = UserRole.find_or_create_by_name(:name => "fan")

niek = User.find_or_create_by_fb_user_id(:fb_user_id => "1185998828")
prutse = User.find_or_create_by_fb_user_id(:fb_user_id => "1697986600")
