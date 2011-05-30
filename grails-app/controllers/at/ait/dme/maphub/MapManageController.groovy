package at.ait.dme.maphub

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN', 'ROLE_USER_RW'])
class MapManageController {

    def springSecurityService

    def index = {
      def user = springSecurityService.getCurrentUser()
      [maps : user.maps, sets: user.sets, user: user ]
    }

}
