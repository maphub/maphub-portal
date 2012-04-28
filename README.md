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