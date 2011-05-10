package at.ait.dme.maphub

class Mapset {
  
  String name
  String description
  Boolean isPublic
  Date uploadDate
  Date editDate
  
  static constraints = {
    name(blank: false)
  }
  
  static hasMany = [ maps : Map ]
  
  static belongsTo = [ user : User ]
  
  static searchable = true
  
}