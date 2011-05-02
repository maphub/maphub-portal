package at.ait.dme.maphub

class MapTagLib {
    
    /* Renders a single thumbnail image of the map */
    def thumbnail = { attrs, body ->
      out << "<img src='"
      out << Map.get(attrs.map.id).tilesetUrl + "/TileGroup0/0-0-0.jpg"
      out << "'/>"
    }
    
    /* Renders a coverflow content item WITHOUT the necessary item surrounding it */
    def coverflowContent = { attrs, body ->
      def map = Map.get(attrs.map.id)
      out << "<img class='content' src='"
      out << map.tilesetUrl + "/TileGroup0/0-0-0.jpg"
      out << "' title='"
      out << map.name
      out << "'/>"
    }
    
    /* Renders a coverflow item that can be used inside the flow */
    def coverflowItem = { attrs, body ->
      def map = Map.get(attrs.map.id)
      out << "<img class='item' src='"
      out << map.tilesetUrl + "/TileGroup0/0-0-0.jpg"
      out << "' title='"
      out << map.name
      out << "' href='"
      out << "/maphub-portal/map/show/" + map.id
      out << "'/>"
    }
    
}
