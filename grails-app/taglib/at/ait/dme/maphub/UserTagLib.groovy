package at.ait.dme.maphub

class UserTagLib {
    
    def rep = { attrs, body ->
      out << "<span class='userRep'>"
      out << attrs.user.reputation
      out << "</span>"
    }
    
}
