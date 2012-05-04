# Windows notes
Doesn't work at all on Windows any more due to libv8 dependency which rubyracer (?) and less depend on. libv8 isn't available, and doesn't compile, on Windows. Ignoring it (which used to work with troublesome dependencies) prevents various things from working (like rails even starting up).

# Ubuntu 12.04 notes
Need to install (sudo apt-get install ...): ruby1.9.1 (which installs 1.9.3), git, rubygems, ruby-bundler, libxml2-dev libxslt-dev sqlite3 libsqlite3-dev rails
Can't run "gem update --system" in Ubuntu, gives a warning about that overwriting Debian files...
Need to run "sudo bundle install", needs to modify /var/lib/gems
Running "rails server" seems to just create/overwrite files.
Need to run "sudo gem update" after "sudo bundle install" to update all the dependencies, like activerecord.



###############################################################################



# About

MapHub is a Web portal for annotating online historic maps. 

## Running Maphub in Development Mode

The following instructions were tested with ruby 1.9.3 and gem 1.8. We recommend [RVM](http://beginrescueend.com/) for controlling your local Ruby environments.

    ruby -v
    gem -v
    
We also recommend to create a separate [RVM Gemset](http://beginrescueend.com/gemsets/) for the MapHub portal:

    rvm gemset create maphub
    rvm gemset use maphub

Optionally you can set maphub to be the default gemset

    rvm use 1.9.3-head@maphub --default

Clone the maphub code on your local machine:

    git clone git@github.com:maphub/maphub-portal.git

Update your gem tool with `gem update --system` and install the bundler gem with `gem install bundler`. `cd` to the project folder and run to install all necessary gems for the maphub tool.
    
    bundle install
    
Then, run the Rails application, probably in a separate console window.

    rails server
    
Create the database and add some test data

    rake db:migrate
    rake db:seed

Finally, open <http://localhost:3000/> in your browser and log into MapHub with `user1@example.com` and `test`. 


## Updating the database / Reindexing data

If you made some changes to the database or first create the database, run the following command, which recreates the database and adds sample data.

    bundle exec rake db:drop && bundle exec rake db:migrate && bundle exec rake db:seed
