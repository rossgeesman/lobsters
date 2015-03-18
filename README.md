###Korean Hacker News Clone "Sabjil"

Forked from the [Lobsters Project](https://github.com/jcs/lobsters/blob/master/CONTRIBUTING.md). Plan on localizing in Korean, making a few changes and deploying.

####Initial setup

* Install Ruby. Supported Ruby versions include 1.9.3, 2.0.0 and 2.1.0.

* Checkout the sabjil git tree from Github

         $ git clone git://github.com/rossgeesman/sabjil.git
         $ cd sabjil
         sabjil$ 

* Run Bundler to install/bundle gems needed by the project:

         sabjil$ bundle

* The Lobsters project officially supports MySQL and MariaDB but we will be using PostgreSQL.
If on a Mac, you can get PostrgreSQL running with the [Postgres.app](http://postgresapp.com).


* After your database is setup and running, load the schema into the new database:

          sabjil$ rake db:schema:load

* (Optional, only needed for the search engine) Install Sphinx.  Build Sphinx
config and start server:

          sabjil$ rake ts:rebuild

* Define your site's name and default domain, which are used in various places,
in a `config/initializers/production.rb` or similar file:

          class << Rails.application
            def domain
              "example.com"
            end
          
            def name
              "Example News"
            end
          end
          
          Rails.application.routes.default_url_options[:host] = Rails.application.domain

* Create an initial administrator user and at least one tag:

          sabjil$ rails console
          Loading development environment (Rails 4.1.8)
          irb(main):001:0> User.create(:username => "test", :email => "test@example.com", :password => "test", :password_confirmation => "test", :is_admin => true, :is_moderator => true)
          irb(main):002:0> Tag.create(:tag => "test")

* Run the Rails server in development mode.  You should be able to login to
`http://localhost:3000` with your new `test` user:

          sabjil$ rails server


#### Docker

##### Build

```
$ docker build -t sapzil/sapzil .
```

##### Run application(production enviroment)

```
$ docker run -it --rm \
    -p 80:80 \
    -e SECRET_KEY_BASE=secretkey \
    -e DATABASE_URL=postgres://postgres:@192.168.59.103/sn_production \
    -e MANDRILL_USERNAME= \
    -e MANDRILL_APIKEY= \
    sapzil/sapzil
```

##### Run rake task

```
$ docker run -it --rm \
    -e SECRET_KEY_BASE=secretkey \
    -e DATABASE_URL=postgres://postgres:@192.168.59.103/sn_production \
    -e MANDRILL_USERNAME= \
    -e MANDRILL_APIKEY= \
    sapzil/sapzil \
    bundle exec rake yourtask
```
