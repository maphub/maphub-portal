package at.ait.dme.maphub

class Annotation {
  
  String title
  String body
  Date uploadDate
  Date editDate
  User user
  
  static belongsTo = [ User, Map ]
  
}