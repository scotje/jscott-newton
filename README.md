# newton

The blogging software named after a dog!

## What is it?

Newton is a minimalist blogging engine designed to allow you to focus on your content. 
It uses an SQLite database so you don't need to have any database software installed.
It generates and caches static files of all your content on demand so your site runs
as fast as your web server.

Newton is intended to be used by developers and others with a certain level of technical
ability and familiarity with HTML, CSS, and Rails. If you aren't comfortable forking
a Git repository and editing some ERB files to customize the look of your blog, this 
may not be the software for you.

## Requirements

- Ruby 1.9.3 (may work with earlier versions, but not tested)
- Bundler

## Installation

1.  Clone this repository (or fork and then checkout your fork, which is the recommended approach):
        
		git clone git://github.com/scotje/newton.git my_blog

1.  Install dependencies:

		cd my_blog
		bundle install
		
1.  Set up database:

		bundle exec rake db:setup RACK_ENV=production
		
1.  Serve with your favorite Rails app aware web server configuration. Make sure to run the app in the "production" environment.

1.  The admin interface is found in /admin and the default username and password is "admin" / "changeme". You can (and should!) change these in the settings area, click on the gear icon.

## Customization

By design, Newton ships with a very minimal fallback theme. You will definitely want to customize the look and feel.

First, I highly recommend creating your own fork of this repository. This will make it easier to keep track of your customizations
while still being easy to integrate updates to Newton into your blog. It will also make it easy for you to contribute changes
back to the project. Assuming you already have a Github account, it couldn't be simpler to create a fork: just click that "Fork" button near
the upper right corner of this page.
