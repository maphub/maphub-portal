package at.ait.dme.maphub

class Annotation {
  
	def mapService

  String title
  String body
  Date uploadDate
  Date editDate
  
  static belongsTo = [ user : User, map : Map ]

  static namedQueries = {
    recentUploadsByDays { days ->
      def now = new Date()
      gt 'uploadDate', now - days
    }
  }

	String serialize() {
		return mapService.serializeOAC(this)
	}
  
}
