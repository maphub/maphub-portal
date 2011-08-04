# Comments/TODOs Bernhard 

* Enhancements
    - Admin login/views doesn't work properly at the moment

* New Features
    - The new/edit annotation view should provide two functionalities: [set control point, add annotation](http://dme.ait.ac.at/annotation/yuma_map_demo_full.htm)
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
    - unregistered users should see a very simple page with some simple (rotating?) map display, a search box and a join/login button; allow them to switch views; for registered users/admins the current home view is OK
    - make use of [HTML5 features](http://html5boilerplate.com/) in application.html.erb and other views. E.g. footer elements, etc...
    
        
# Comments/TODO Werner

- TODO get the width/height of a Zoomify Tileset and include it in the javascript that is executed before loading, otherwise the map will be stretched

- BUGFIX the jQuery synchronization in `collections/_form` (especially when selecting all / deselcting)

- BUGFIX editing a map (tileset seems to be gone?)

- Porting views (browsing):
  - add various viewing methods (list/coverflow)
  - add [pagination](https://github.com/mislav/will_paginate)

- Admin interface
  - administrate users
  - administrate annotations
  - administrate maps

- Security
  - secure controllers

- Registration
  - text for registration mails