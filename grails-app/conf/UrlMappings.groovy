class UrlMappings {

	static mappings = {

    "/"(controller:'home',action:'index') 

/*    "/user/$userId/browse" {
      controller = "map"
      action = "browse"
    }

    "/user/$userId/list" {
      controller = "map"
      action = "list"
    }

    "/user/$userId/coverflow" {
      controller = "map"
      action = "coverflow"
    }*/

    "/$controller/$action?/$id?"{
    	constraints {
    		// apply constraints here
    	}
    }

		"/search"(controller:'siteSearch')
		"/searchable"(controller:'siteSearch')

		/*"/"(view:"/index")*/
		"500"(view:'/error')
	}
}
