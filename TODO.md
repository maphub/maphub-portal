# Comments/TODOs Bernhard 

* Enhancements
    - Admin login/views doesn't work properly at the moment

* New Features
    - Integrate OpenLayers into Annotation view
    - The new/edit annotation view should provide two functionalities: set control point, add annotation
        - control points:
            - let the user set a point on the map and display an input field asking for the name of the place
            - provide a service in /lib that talks with Geonames (basically a ruby port of the YUMA code)
            - enhance annotation model to store control points (long/lat/geonames ref)
        - annotations:
            - let the user draw areas on on the map
            - integrate rainer's tag cloud
            - provide a service in /lib that talks with DBpedia
    - implement search over maps using http://outoftime.github.com/sunspot/
    - reconsider map attributes; check what LoC metadata fields we have
    - redirect rdf/xml requests on annotations to an OAC-ruby implementation in lib/ (can later be pulled out into a separate API)

* GUI / Views
    - unregistered users should see a very simple page with some simple (rotating?) map display, a search boy and a join/login button; allow them to switch views; for registered users/admins the current home view is OK
    - make use of HTML5 features in application.html.erb and other views. E.g. footer elements, etc...
    
        
# Comments/TODO Werner

- Fix the jQuery synchronization in `collections/_form`

- Porting views (browsing):
  - add various viewing methods (list/coverflow)
  - add [pagination](https://github.com/mislav/will_paginate)

- Partials
  - extend partials to include [optional parameter](http://stackoverflow.com/questions/2385525/how-to-have-an-optional-local-variable-in-a-partial-template-in-rails) "user", for example

    recent maps => all recent maps
    recent maps (user = ...) => all recent maps from this user
  
- Admin interface
  - administrate users
  - administrate annotations
  - administrate maps

- Security
  - secure controllers

- Registration
  - text for registration mails