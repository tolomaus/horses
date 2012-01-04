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

user_role = UserRole.find_or_create_by_name(:name => "Representative")
user_role = UserRole.find_or_create_by_name(:name => "Rider")
user_role = UserRole.find_or_create_by_name(:name => "Owner")
user_role = UserRole.find_or_create_by_name(:name => "Groom")
user_role = UserRole.find_or_create_by_name(:name => "Trainer")
user_role = UserRole.find_or_create_by_name(:name => "Fan")

