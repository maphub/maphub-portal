package at.ait.dme.maphub

class Map {

	String tilesetUrl

    static constraints = {
    	tilesetUrl(blank: false)
    }
}
