package at.ait.dme.maphub

class HomeController {

    def index = {
      
      def recentMaps = Map.recentUploadsByDays(7).list(max: 5)
      def recentAnnotations = Annotation.recentUploadsByDays(7).list(max: 5)
      
      [recentMaps: recentMaps, recentAnnotations: recentAnnotations]
    }
    
    def help = {
      
    }
    
    def tos = {
      
    }
    
    def contact = {
      
    }
    
}