# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

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

# Create example maps
puts "Creating maps ..."

map_ids = File.open("#{::Rails.root.to_s}/db/map-ids.txt")
map_ids.each_with_index do |id, index|
  id.chomp!
  break if index == 30
  Map.create do |map|
    map.title = "Map #{index+1}"
    map.description = "This is a sample description"
    map.tileset_url = "http://europeana.mminf.univie.ac.at/maps/#{id}"
    map.user = User.first
  end
  puts "Created map #{index+1}"
end
