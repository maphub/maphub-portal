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
      [user: user]
    }

		def update = {
		  def user = springSecurityService.getCurrentUser()
		}

}
