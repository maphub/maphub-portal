import grails.util.Environment
import at.ait.dme.maphub.Map
import at.ait.dme.maphub.Role
import at.ait.dme.maphub.User
import at.ait.dme.maphub.UserRole

class BootStrap {

	final TESTDATA_BASE_URI = "http://europeana.mminf.univie.ac.at/maps/"
	final TESTDATA_IMPORT_COUNT = 30

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
		def roles = ["ROLE_ADMIN", "ROLE_USER_RW", "ROLE_USER_RO"]
		roles.each() {
			if (!Role.findByAuthority(it)) {
				new Role(authority: it).save(flush: true)
			}
		}
	}

	void createAdminUserIfRequired() {
		if (!User.findByUsername(ADMIN_USER_NAME)) {
			def admin = createUser(ADMIN_USER_NAME, ADMIN_USER_NAME)
			UserRole.create(admin, Role.findByAuthority("ROLE_ADMIN"), true)
		}
	}

	void createAverageJoeUsersIfRequired() {
		if (!User.findByUsername(WRITE_ACCESS_USER_NAME)) {
			def uploadUser = createUser(WRITE_ACCESS_USER_NAME, WRITE_ACCESS_USER_NAME)
			UserRole.create(uploadUser, Role.findByAuthority("ROLE_USER_RW"), true)
		}
		if (!User.findByUsername(READONLY_USER_NAME)) {
			def readOnlyUser = createUser(READONLY_USER_NAME, READONLY_USER_NAME)
			UserRole.create(readOnlyUser, Role.findByAuthority("ROLE_USER_RO"), true)
		}
	}

	User createUser(name, pwd) {
		String password = springSecurityService.encodePassword(name)
		def user = new User(username: name, enabled: true, password: password)
		user.save(flush: true)
		return user
	}

	void insertTestData() {
		def adminUser = User.findByUsername(ADMIN_USER_NAME)

		new File("maps_index.txt").eachLine { line, nr ->
			def mapUri = TESTDATA_BASE_URI + line
			if (nr <= TESTDATA_IMPORT_COUNT && !Map.findByTilesetUrl(mapUri)) {
			  def name = "Test Map " + nr
			  def date = new Date();
				new Map(tilesetUrl: mapUri, user: adminUser, name: name, views: 0, description: "Description", uploadDate: date, mapDate: date).save(flush: true)
			}
		}
	}

}
