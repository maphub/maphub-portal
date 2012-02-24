About
==========================================================

MapHub is a Web portal for annotating online historic maps.


Running Maphub in Development Mode
==========================================================

Make sure that you have ruby 1.9.2 and gem 1.3.7 installed. We recommend [RVM](http://beginrescueend.com/) for controlling your local
Ruby environments.

    ruby -v
    gem -v

Clone the maphub code on your local machine:

    git clone git@github.com:yuma-annotation/maphub-portal.git

Update your gem tool and install the bundler gem:

    gem update --system
    gem update
    gem install bundler

Then `cd` to the project folder and run to install all necessary gems for the maphub tool.
    
    bundle install
    
Then, run the Rails application, probably in a separate console window, with...

    rails server
    
...and start the Sunspot/Solr search engine

    rake sunspot:solr:start

If you want to add test data, run

    rake db:seed
    
If you made some changes to the database or first create the database, run

    rake db:drop; rake db:migrate; rake db:seed
    
Open <http://localhost:3000/> in your browser and log into MapHub with `user1@example.com` and `test`. 

In case you change something in your models, don't forget to reindex Sunspot:

    rake sunspot:reindex


Deploying Maphub in Production Mode
=======================================

Setup MYSQL DB-Backend
----------------------

We have to install MySQL if we want to use it locally, or if we want to connect to a remote server:

- Install `mysql` (e.g., via Homebrew on OS X, see here: <http://solutions.treypiepmeier.com/2010/02/28/installing-mysql-on-snow-leopard-using-homebrew/>) and up and running
- Install the `libmysqlclient` libraries for the gems we need later
- A useful MYSQL cheat sheet is located here: <http://www.pantz.org/software/mysql/mysqlcommands.html>

Then create an appropriate database and user, either locally ...

    mysql -u <username> -p
    CREATE DATABASE maphub;
    GRANT ALL PRIVILEGES ON maphub.* TO 'maphub'@'localhost' IDENTIFIED BY 'maphub' WITH GRANT OPTION;
    flush privileges;

... or we can also use a remote server:

    mysql --host <remote-host> --user=<username> -p
    CREATE DATABASE maphub;
    GRANT ALL PRIVILEGES ON maphub.* TO 'maphub'@'<your-source-ip>' IDENTIFIED BY 'maphub' WITH GRANT OPTION;
    flush privileges;
    
On OS X, we have to use a special command to start the MySQL server (if it was installed by Homebrew, that is):

    launchctl load -w /usr/local/Cellar/mysql/5.1.54/com.mysql.mysqld.plist 

Setup sqlite3 for Development
----------------------------

To test the database locally, `sqlite3` is used. Install `sqlite3` and `sqlite3-devel` for that purpose.

Setup Apache2
-------------

Rails needs Apache2 to work, so just install `apache2` and make sure it will run and your server is reachable on port 80 (and optionally 3000 for testing). We will later configure Rails integration with Apache.

Install Ruby and the Project
----------------------------

Use SVN to check out the project trunk or a tagged version in some folder. Then install RVM, the Ruby version manager: <http://rvm.beginrescueend.com/rvm/install/>. Use

    rvm install 1.9.2
    
to install Ruby 1.9.2 and set it as default with

    rvm --default 1.9.2
    
Open a new terminal or logout and login again. Check if you have the correct versions by calling

    ruby -v
    gem -v

These should be 1.9.2 and 1.3.7. Now to installing and configuring Rails. Install Ruby on Rails 3.0.3 with

    gem install rails

Then `cd` to the project and run 
    
    bundle install

to install all necessary gems for the maphub tool.

Configuring Passenger
----------------------

Passenger is needed for Apache2 to serve the Rails project. Install Passenger with `gem install passenger`. Run `passenger-install-apache2-module` and eventually install missing libraries.

Then, add these lines in your Apache2 config (probably `/etc/apache2/conf.d/httpd.conf`):

    LoadModule passenger_module /home/maphub/.rvm/gems/ruby-1.9.2-p136/
        gems/passenger-3.0.2/ext/apache2/mod_passenger.so
    PassengerRoot /home/maphub/.rvm/gems/ruby-1.9.2-p136/gems/passenger-3.0.2
    PassengerRuby /home/maphub/.rvm/wrappers/ruby-1.9.2-p136/ruby

Suppose you have the Rails application checked out in `/somewhere`. Add a virtual host to your Apache configuration file and set its DocumentRoot to `/somewhere/public`:

    <VirtualHost *:80>
      ServerName www.yourhost.com
      DocumentRoot /somewhere/public
      <Directory /somewhere/public>
         Allow from all
         AllowOverride all
         Options -MultiViews
      </Directory>
    </VirtualHost>

Finally, restart Apache with `/etc/init.d/apache2 restart` and check if you see something (probably an error message from Rails).

Installing readline
-------------------

Sometimes the `readline` library isn't compiled into Ruby by default. You will notice this when trying out the Rails console. Change to `/home/<username>/.rvm/src/ruby-1.9.2-p136/ext/readline` and run `ruby extconf.rb` to see the missing packages. Those are probably:

- libreadline5-devel
- libncurses5-devel

Install them by using Yast or Aptitude. Then run:
    
    ruby extconf.rb
    make
    make install

Configuring the Application
===========================

Mail Configuration
------------------

Mails will be sent automatically by Compass. Change the name of the host that runs the project in `config/environments/production.rb:19`:

    config.action_mailer.default_url_options = { 
      :host => 'maphub.com' 
    }
    
Also change the e-mail that system mails appear to come from in: `config/initializers/devise.rb:6`

    config.mailer_sender = "noreply@maphub.com"


Activate MySQL Production Backend
---------------------------------

First, change the parameters in `config/database.yml` to your new production environment. Enter the host, username, password and database name that you used earlier when creating the database.

If you can connect to the MySQL server, you may drop the existing database, then create the schema again. Drop all data in the production database (**CAREFUL: This will delete all existing data**):

    RAILS_ENV='production' rake db:drop
    
Then create the empty database and load the schema:

    RAILS_ENV='production' rake db:create
    RAILS_ENV='production' rake db:schema:load

You might then want to import a data dump (see "Dumping and Migrating Data").

Admin creation via Console
--------------------------

Locally create an Admin user in the database by running `rails console production` and entering (line by line):

    Admin.create! do |u|
      u.email = 'sample@sample.com'
      u.password = 'password'
      u.password_confirmation = 'password'
    end

The Admin login view is located under: <http://your-server-url/admin>


Dumping and Migrating Data
==========================

If you want to export and re-import the data from one to another server, make sure that the `yaml_db` gem is installed. You will find it on [GitHub](https://github.com/ludicast/yaml_db). Just add the following line to your `Gemspec`:

    gem 'yaml_db'

You can export the data from a rails application by `cd`ing to `db` and calling the following command:

    RAILS_ENV='production' rake db:data:dump

Your file should be called `data.yml`. Copy this data file to the new server, change to the `db` directory and call:

    RAILS_ENV='production' rake db:data:load

The database should be migrated to the new server.

Adding columns
--------------

We keep everything within one migration file (`under db/migrate/*.rb`). Edit this file accordingly, make a backup, then do the following steps:

    rake db:data:dump
    rake db:drop
    rake db:create
    rake db:migrate
    rake db:data:load

Now your new columns/tables should appear.