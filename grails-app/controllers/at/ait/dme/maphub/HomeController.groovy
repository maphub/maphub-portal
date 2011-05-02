package at.ait.dme.maphub

class HomeController {

    def index = {
      
      def recentMaps = Map.recentUploadsByDays(7).list(max: 10)
      
      [recentMaps: recentMaps]
    }
    
}