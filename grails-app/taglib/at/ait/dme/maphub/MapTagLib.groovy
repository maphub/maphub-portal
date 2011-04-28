package at.ait.dme.maphub

class MapTagLib {
    
    def thumbnail = { attrs, body ->
      out << "<img src='"
      out << Map.get(attrs.map.id).tilesetUrl + "/TileGroup0/0-0-0.jpg"
      out << "'/>"
    }
    
}
