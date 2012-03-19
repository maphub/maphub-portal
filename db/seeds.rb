# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create example users
puts "Creating admins ..."
Admin.create do |a|
  a.username = 'admin'
  a.password = 'test'
  a.password_confirmation = 'test'
  a.email = 'admin@example.com'
end


puts "Creating users ..."
for i in 1..10 do
  User.create do |a|
    a.username = "user#{i}"
    a.password = 'test'
    a.password_confirmation = 'test'
    a.email = "user#{i}@example.com"
    a.location = "Vienna, Austria"
    a.fullname = "Test User #{i}"
  end
  puts "Created user #{i}"
end
