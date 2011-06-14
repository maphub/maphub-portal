package at.ait.dme.maphub

class Annotation {
  
	def mapService

  String title
  String body
  Date uploadDate
  Date editDate
  
  static belongsTo = [ user : User, map : Map ]

	String serialize() {
		return mapService.serializeOAC(this)
	}
  
}
