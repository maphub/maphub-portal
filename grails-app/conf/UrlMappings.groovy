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
    
    // remapping in order to include User ID in the URL
    
    "/map/$userId/$id/" {
      controller = "map"
      action = "show"
    }
/*
    "/mapset/$userId/$id/" {
      controller = "mapset"
      action = "show"
    }
    */
    // General route

    "/$controller/$action?/$id?"{
    	constraints {
    		// apply constraints here
    	}
    }
    
    // Search alias

		"/search"(controller:'siteSearch')
		"/searchable"(controller:'siteSearch')

		/*"/"(view:"/index")*/
		"500"(view:'/error')
	}
}
