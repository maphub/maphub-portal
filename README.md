# About

MapHub is a Web portal for annotating online historic maps.

## Running Maphub in Development Mode

Make sure that you have ruby 1.9.2 and gem > 1.8 installed. We recommend [RVM](http://beginrescueend.com/) for controlling your local Ruby environments.

    ruby -v
    gem -v

Clone the maphub code on your local machine:

    git clone git@github.com:yuma-annotation/maphub-portal.git

Update your gem tool with `gem update --system` and install the bundler gem with `gem install bundler`. `cd` to the project folder and run to install all necessary gems for the maphub tool.
    
    bundle install
    
Then, run the Rails application, probably in a separate console window, with...

    bundle exec rails server
    
...and start the Sunspot/Solr search engine

    bundle exec rake sunspot:solr:start

Create the database and add some test data

    bundle exec rake db:migrate
    bundle exec rake db:seed
    

Finally, open <http://localhost:3000/> in your browser and log into MapHub with `user1@example.com` and `test`. 


## Updating the database / Reindexing data

If you made some changes to the database or first create the database, run

    bundle exec rake db:drop; rake db:migrate; rake db:seed
    
In case you change something in your models, don't forget to reindex Sunspot:

    bundle exec rake sunspot:reindex
    

## Advanced Stuff

For deploying Maphub in production mode, follow [this guide](https://github.com/maphub/maphub-portal/wiki/Deploy-Maphub-in-production-mode) 