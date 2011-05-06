class UrlMappings {

	static mappings = {
	  
    "/"(controller:'home',action:'index') 
	  
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
