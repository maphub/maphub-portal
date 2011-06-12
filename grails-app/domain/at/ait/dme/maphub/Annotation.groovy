package at.ait.dme.maphub

class Annotation {
  
	def mapService

  String title
  String body
  Date uploadDate
  Date editDate
  User user
  
  static belongsTo = [ User, Map ]

	String serialize() {
		return mapService.serializeOAC(this)
	}
  
}
