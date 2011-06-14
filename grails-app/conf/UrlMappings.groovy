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
    
/*
    "/mapset/$userId/$id/" {
      controller = "mapset"
      action = "show"
    }
    */
    
/*  
    This doesn't work. Enable it and go to /map/browse. Why?
    "/map/$id" {
      controller = "map"
      action = "show"
    }
*/    
    "/profile/$id" {
      controller = "profile"
      action = "show"
    }
    
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
