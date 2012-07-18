# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_dir
    ENV['SEED_DIR'] || File.dirname(__FILE__) + '/seeds'
end

# Create example users
puts "Creating admins ..."
Admin.create do |a|
  a.username = 'admin'
  a.password = 'test'
  a.password_confirmation = 'test'
  a.email = 'admin@example.com'
end

puts "Creating users ..."
for i in 1..3 do
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

# Create sample maps, either seed from YAML file in maphub-portal/db/seeds/seeddata.yaml
seed_file = "#{seed_dir}/maps.yaml"
if File.exists?(seed_file)
  YAML.load_documents(File.open(seed_file, "r")) do |entry|
    Map.create do |map|
      map.identifier  = entry["id"]
      map.title       = entry["title"]
      map.subject     = entry["subject"]
      map.author      = entry["author"]
      map.date        = entry["date"]
    end
    puts "Created map #{entry['map']}"
  end
# or from dummy variables
else
  maps = ["g3200.ct001129", 
          "g3201b.ct002662",
          "g3300.ar000600",
          "g3300.ar003300",
          "g3300.ct000912",
          "ct002033"]

  puts "Creating sample maps"

  maps.each_with_index do |id, index|
    new_map = Map.new do |map|
      puts "Creating map #{id}"
      map.identifier  = id
      map.title       = "Map #{index+1}"
      map.subject     = "Subject of this map."
      map.author      = "Anonymous"
      map.date        = "1877"
    end
    unless new_map.valid?
      puts "Can't validate map. Please check if the map really exists at <#{new_map.tileset_uri}>"
    end
    new_map.save
  end
  
  puts "Creating demonstrator Maps"
  
  demo_map = Map.new
  demo_map.identifier = "g3200.ct000725C"
  demo_map.title = "Universalis cosmographia secundum Ptholomaei traditionem et Americi Vespucii alioru[m]que lustrationes"
  demo_map.subject = "World maps"
  demo_map.author = "Waldseemueller, Martin"
  demo_map.date = "1507"
  demo_map.save

end