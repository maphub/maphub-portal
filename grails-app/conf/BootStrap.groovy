import grails.util.Environment
import at.ait.dme.maphub.Role
import at.ait.dme.maphub.User
import at.ait.dme.maphub.UserRole

class BootStrap {

	final ADMIN_ROLE_AUTHORITY = "ROLE_ADMIN"
	final WRITE_ACCESS_USER_ROLE_AUTHORITY = "ROLE_USER_RW"
	final READONLY_ACCESS_USER_ROLE_AUTHORITY = "ROLE_USER_RO"

	final ADMIN_USER_NAME = "admin"
	final WRITE_ACCESS_USER_NAME = "rwuser"
	final READONLY_USER_NAME = "rouser"

	def springSecurityService

	def init = { servletContext ->
		if (Environment.current == Environment.DEVELOPMENT) {
			createUserStuff()
			insertTestData()
		}
	}

	def destroy = {
	}

	void createUserStuff() {
		createRolesIfRequired()
		createAdminUserIfRequired()
		createAverageJoeUsersIfRequired()		
	}

	void createRolesIfRequired() {
		def roles = [ADMIN_ROLE_AUTHORITY, WRITE_ACCESS_USER_ROLE_AUTHORITY, READONLY_ACCESS_USER_ROLE_AUTHORITY]
		roles.each() {
			if (!Role.findByAuthority(it)) {
				new Role(authority: it).save(flush: true)
			}
		}
	}

	void createAdminUserIfRequired() {
		if (!User.findByUsername(ADMIN_USER_NAME)) {
			def admin = createUser(ADMIN_USER_NAME, ADMIN_USER_NAME)
			UserRole.create(admin, Role.findByAuthority(ADMIN_ROLE_AUTHORITY), true)
		}
	}

	void createAverageJoeUsersIfRequired() {
		if (!User.findByUsername(WRITE_ACCESS_USER_NAME)) {
			def uploadUser = createUser(WRITE_ACCESS_USER_NAME, WRITE_ACCESS_USER_NAME)
			UserRole.create(uploadUser, Role.findByAuthority(WRITE_ACCESS_USER_ROLE_AUTHORITY), true)
		}
		if (!User.findByUsername(READONLY_USER_NAME)) {
			def readOnlyUser = createUser(READONLY_USER_NAME, READONLY_USER_NAME)
			UserRole.create(readOnlyUser, Role.findByAuthority(READONLY_ACCESS_USER_ROLE_AUTHORITY), true)
		}
	}

	User createUser(name, pwd) {
		String password = springSecurityService.encodePassword(name)
		def user = new User(username: name, enabled: true, password: password)
		user.save(flush: true)
		return user
	}

	void insertTestData() {

	}

}
