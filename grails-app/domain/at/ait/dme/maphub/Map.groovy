package at.ait.dme.maphub

class Map {

  String tilesetUrl
  String name
  String description
	Integer views
  Date uploadDate
  Date mapDate
	Boolean isPublic

  static constraints = {
  	tilesetUrl(url: true, blank: false, unique: true)
  }
  
  static namedQueries = {
    recentUploadsByDays { days ->
      def now = new Date()
      gt 'uploadDate', now - days
    }
  }
  
  static belongsTo = [ user : User ]
  
  static searchable = true

}
