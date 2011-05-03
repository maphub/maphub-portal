package at.ait.dme.maphub

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN', 'ROLE_USER_RW', 'ROLE_USER_RO'])
class ProfileController {

		def springSecurityService

    def index = {
		  def user = springSecurityService.getCurrentUser()
      redirect(action: show, id: user.id)
		}
		
		def edit = {
		  def user = springSecurityService.getCurrentUser()
		  [user: user]
		}

    def show = {
      def user = User.get(params.id)
      def self = false
      if (user.id == springSecurityService.getCurrentUser().id) {
        self = true
      }
      
      def mapsCount = Map.findAllByUser(user).size
      def maps = Map.findAllByUser(user, [max: 10])
      
      [user: user, self: self, maps: maps, mapsCount: mapsCount]
    }

		def update = {
		  def user = springSecurityService.getCurrentUser()
		}

}
