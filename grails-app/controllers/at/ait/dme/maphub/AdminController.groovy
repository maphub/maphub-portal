package at.ait.dme.maphub

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN'])
class AdminController {

    def index = {

    }

}