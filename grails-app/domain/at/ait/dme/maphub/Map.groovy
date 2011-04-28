package at.ait.dme.maphub

class Map {

  String tilesetUrl
  String name
  String description
  Date uploadDate
  Date mapDate

  static constraints = {
  	tilesetUrl(url: true)
  }

  static belongsTo = [ user : User ]
  
  static searchable = true

}
