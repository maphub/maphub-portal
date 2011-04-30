The MapHub Portal Project
=========================

Installation and Running
------------------------

This is a Grails project. You need to download Grails from [http://grails.org/](http://grails.org/) 
and set it up on your machine. 

1. Download Grails from the website
2. Extract it somewhere and point the `GRAILS_HOME` variable to this folder
3. Add  the Grails `/bin` folder to your system `PATH`!


First Steps
-----------

1. Clone the repository
2. In the `grails-app/conf` folder, locate the file `DataSource.groovy.template`.
3. Create a copy of this file named `DataSource.groovy`. **Important:** please don't just rename the file. If you do, you might accidentally delete the `.template` from the repository on your next commit!
4. You can edit the contents of DataSource.groovy to match your local database settings, if you want (per default, you will be running on an in-memory database.
5. To verify everything is set up, change to the project folder, type  `grails run-app`, and go to [http://localhost:8080/maphub-portal](http://localhost:8080/maphub-portal) after the server has started.