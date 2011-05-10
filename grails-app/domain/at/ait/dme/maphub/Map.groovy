package at.ait.dme.maphub

class Map {

  String tilesetUrl
  String name
  String description
	Integer views
  Date uploadDate
  Date mapDate
	Boolean isPublic
	User user

  static constraints = {
  	tilesetUrl(url: true, blank: false, unique: true)
  	name(blank: false)
  }
  
  static namedQueries = {
    recentUploadsByDays { days ->
      def now = new Date()
      gt 'uploadDate', now - days
    }
  }
  
  static belongsTo = [ User, Mapset ]
  
  static hasMany = [ mapsets : Mapset ]
  
  static searchable = true

}
