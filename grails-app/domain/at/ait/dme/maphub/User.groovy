package at.ait.dme.maphub

class User {

	String username
	String password
	String description
	Integer reputation
	Date registerDate
	Date lastLoginDate
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	static constraints = {
		username blank: false, unique: true
		password blank: false
	}

	static mapping = {
		password column: '`password`'
	}

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this).collect { it.role } as Set
	}

	static hasMany = [ maps : Map ]

}
