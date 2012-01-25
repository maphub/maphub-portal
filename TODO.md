# A list of maphub TODOs

* Seed data script
	- check downloaded map images + metadata files (empty / non-empty)
	- decide which metadata fields to map to map's "title", "description", and "subject" attributes (maybe further fields are needed)
	- check how http://memory.loc.gov/ammem/gmdhtml/ are reflected in metadata -> assignment to maphub collections
	- implement script "create_seed_data.rb" that produces a YAML file with configurable size N from map + metadata fields

* DBPedia lookup + Tagcloud
	- get rid of annotation title
	- whenever user enters an annotation; scan text and check for possible DBPedia entities
	- display tag cloud right beside the panel
	- implement DBPedia lookup as standalone class in /lib directory
	
* Implement Open Annotation Collaboration model
	- requests against annotation URIs should deliver serializations that follow the OAC model
	- implement either by request extension ".rdf" or by conneg
	- implement OAC serialization logic in lib directory -> extract into separate library later on

* Implement different work flows for registered / unregistered users
	- unregistered:
		- present sample maps and user annotation on welcome screen
		- allow them to click on a single map and see details
	- registered:
		- full functionality
	
* Implement Admin Interface
   	- admin users, annotations, maps, collections (if possible in separate /admin namespace)