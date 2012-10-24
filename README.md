# newton

The blogging software named after a dog!

## What is it?

Newton is a minimalist blogging engine designed to allow you to focus on your content. 
It uses an SQLite database so you don't need to have any database software installed.
It generates and caches static files of all your content on demand so your site runs
as fast as your web server.

## Requirements

- Ruby 1.9.3 (may work with earlier versions, but not tested)
- Bundler

## Installation

1.  Checkout this repository (or fork and then checkout your fork):
        
		git checkout git://github.com/scotje/newton.git my_blog

1.  Install dependencies:

		cd my_blog
		bundle install
		
1.  Set up database:

		bundle exec rake db:setup RACK_ENV=production
		
1.  Serve with your favorite Rails app aware web server configuration. Make sure to run the app in the "production" environment.

1.  The admin interface is found in /admin and the default username and password is "admin" / "changeme". You can (and should!) change these in the settings area, click on the gear icon.

## Customization

Documentation coming soon.