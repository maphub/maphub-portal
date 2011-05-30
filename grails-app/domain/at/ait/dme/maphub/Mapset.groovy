package at.ait.dme.maphub

class Mapset {
  
  String name
  String description
  Boolean isPublic
  Date uploadDate
  Date editDate
  User user
  
  static constraints = {
    name(blank: false)
  }
  
  static hasMany = [ maps : at.ait.dme.maphub.Map ]
  
  static belongsTo = [ user : User ]
  
  // static searchable = true
  
}