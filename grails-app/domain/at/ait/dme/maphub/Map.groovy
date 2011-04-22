package at.ait.dme.maphub

class Map {

	String tilesetUrl

  static constraints = {
  	tilesetUrl(url: true)
  }

	static belongsTo = [ user : User ]

}
