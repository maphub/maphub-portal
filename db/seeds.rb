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
          "g3300.ct000912"]

  puts "Creating sample maps"

  maps.each_with_index do |id, index|
    Map.create do |map|
      map.identifier  = id
      map.title       = "Map #{index+1}"
      map.subject     = "Lorem ipsum dolor sit amet. Sunt in culpa qui officia deserunt mollit anim id est laborum."
      map.author      = "Anonymous"
      map.date        = "1877"
    end
    puts "Created map #{id}"
  end
end