namespace :maphub do
  namespace :maps do
    desc "Check all maps for existing Google Maps overlay tilesets"
    task :overlaycheck => :environment do
      Map.all.each do |map| 
        print "Checking existing overlays for #{map.identifier} at <#{map.overlay_tileset_uri}> ..."
        print map.check_for_overlay
        puts
      end
    end
  end
end