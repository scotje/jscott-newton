# newton

The blogging software named after a dog!

## What is it?

Newton is a minimalist blogging engine designed to allow you to focus on your 
content. It uses an SQLite database so you don't need to have any database 
software installed. It generates and caches static files of all your content on 
demand so your site runs as fast as your web server.

Newton is intended to be used by developers and others with a certain level of 
technical ability and familiarity with HTML, CSS, and Rails. If you aren't 
comfortable forking a Git repository and editing some ERB files to customize 
the look of your blog, this may not be the software for you.

## Requirements

- Ruby 1.9.3 (may work with earlier versions, but not tested)
- Bundler

## Installation

1.  Clone this repository (or fork and then clone your fork, which is the recommended approach):
        
		git clone --recursive git://github.com/scotje/newton.git my_blog
		
	You need to do a recursive clone so that you get the Ace Editor which Newton uses for editing the source of your posts. If you have a version of Git older than 1.6.5 you will need to do this instead:
	
		git clone git://github.com/scotje/newton.git my_blog
		cd my_blog
		git submodule update --init

1.  Install dependencies:

		cd my_blog
		bundle install
		
1.  Set up database:

		bundle exec rake db:setup RACK_ENV=production
		
1.  Serve with your favorite Rails app aware web server configuration. Make sure to run the app in the "production" environment.

1.  The admin interface is found in /admin and the default username and password is "admin" / "changeme". You can (and should!) change these in the settings area, click on the gear icon.

## Customization

By design, Newton ships with a very minimal fallback theme. You will definitely 
want to customize the look and feel.

### Bootstrapping Your Development Environment

First, I highly recommend creating your own fork of this repository. This will 
make it easier to keep track of your customizations while still being easy to 
integrate updates to Newton into your blog. It will also make it easy for you 
to contribute changesback to the project. Assuming you already have a Github 
account, it couldn't be simpler to create a fork: just click that "Fork" button 
near the upper right corner of this page.

1.  To get started, follow steps 1 and 2 from the installation instructions above, except instead of cloning from scotje/newton.git, 
    clone from your fork. Also, you should be cloning to your local machine now rather than to your server most likely.

1.  Next, set up your development database:

		bundle exec rake db:setup

1.	Set up the original Newton repository as your "upstream" remote:

		git remote add upstream git://github.com/scotje/newton.git

1.  Create a branch to work in, you can call it whatever you want, I like 'develop':

		git branch develop
		
1.	Push your new branch up to your origin remote (which should be your fork on Github):

		git push origin develop
		
1.  Checkout your development branch:

		git checkout develop

1.  Start your development server:

		bundle exec rails server
		
1.  You should now be able to view your (rather barren) blog at http://0.0.0.0:3000/ and the admin interface at http://0.0.0.0:3000/admin/

If you would like to inject some sample posts into your development blog while 
you work on the formatting, you can use Factory Girl from the console:
	
	bundle exec rails console
	> require 'faker'
	> FactoryGirl.create_list(:post, 5, :published)
	> quit
		
This will create 5 published posts. There are some other traits you can add to 
test different post content. Have a look at spec/factories/posts.rb to see 
what's available. You can also generate some sample pages using the Page 
factory if you like.

### Customizing Templates

Inside the "app/views" folder you will find an empty folder named "_custom". To 
override any of the built-in templates, you need to put your template inside 
this folder and mimic the directory structure and base naming of the template 
you wish to override. For example, if you want to replace the "posts/index" 
template, you would create a folder named "posts" inside the "_custom" folder 
and then a template named "index.html.erb". Your custom templates do not have 
to be written with ERB, however if you use another templating language you may 
have to add the required gems to the Gemfile.

When you override a template like this, the built-in template will not be used 
at all.

You can also override the admin templates if you want to, although this is 
discouraged because it may make it more difficult for you to integrate upstream 
changes in the future.

Here is a list of the templates you will most likely want to modify:

- layouts/application (This is the main template for all the user facing pages.)
- posts/_post_list (This partial is used for rendering a list of posts, like on the index page or an archive page.)
- posts/_post (This partial is used for rendering an individual post, either as part of a list or by itself.)
- pages/show (Used for rendering a page.)

Here are the instance variables available to your custom templates:

#### All Templates

- **@settings**: A nested hash of all the system and user settings defined for your blog. See "Working With Settings" below.
- **@blog_title**: A shortcut to the "blog.title" setting.

#### Post List Templates (Index, Archive, etc.)

- **@posts**: An array of posts to be shown on the page. (See "Post Show Template" below for methods avaialble on each post.)
- **@title**: For archive pages, a description of the type of archive being shown. (Ex: "Posts by Month: July 2012")

#### Post Show Template

- **@post**:
    - **.title**: Title of post, plain text.
	- **.slug**: URL safe identifier for this post. (Usually similar to title.)
	- **.post_type**: String indicating post type. Currently one of: 'link', 'prose', 'picture', or 'video'.
	- **.body**: Body of post in Markdown format.
	- **.created_at**: Timestamp of when post was first created.
	- **.updated_at**: Timestamp of when post was last updated.
	- **.published_at**: Timestamp of when post was first published.
	- **.published?**: Convenience method for whether or not post is currently published. Returns boolean.
	- **.html**: Body of post in HTML format.

#### Page Show Template

- **@page**:
	- **.title**: Title of page, plain text.
	- **.slug**: URL safe identifier for this page. (Usually similar to title.)
	- **.body**: Body of page in Markdown format.
	- **.created_at**: Timestamp of when page was first created.
	- **.updated_at**: Timestamp of when page was last updated.
	- **.published_at**: Timestamp of when page was first published.
	- **.published?**: Convenience method for whether or not page is currently published. Returns boolean.
	- **.html**: Body of page in HTML format.

### Customizing CSS and JavaScript

CSS and JavaScript customization works slightly differently than template 
customization. Instead of completely overriding the built-in stylesheets and 
scripts, your customizations will simply be included last and thus have 
the highest precedence.

Inside the "app/assets/stylesheets" and "app/assets/stylesheets/admin"
folders you will find folders named "_custom". Inside these folders you
will find a file called "custom.css.scss". This file will be imported 
into the public and admin stylesheets (respectively) after all built in 
styles have already been defined. Feel free to create your own 
stylesheets inside the "_custom" folders and import them into the 
"custom.css.scss" file. SCSS is a "Sassy CSS" and is a superset of 
CSS3 syntax defined by the [SASS project](http://sass-lang.com/).

Inside the "app/assets/javascripts" folders you will find an empty folder 
named "_custom". Any files you place in this folder (or any subfolders you 
create) will be included in the user facing portion of your blog. Similarly, 
there is a "_custom" folder inside of "app/assets/javascripts/admin" and code 
placed there will be included in the admin portion of your blog.

So if you were using the built-in templates but wanted to customize the color of 
post headlines, you could create a custom SCSS stylesheet with the following 
content:

	article {
		header {
			h1 {
				color: red;
			}
		}
	}

If you want to completely bypass the built-in stylesheets and scripts, you can 
always customize your layout template so that it only includes your custom 
stylesheets and scripts.

### Working With Settings

In Newton, there are two types of settings: "system" and "user". System settings 
are built-in (created when you seed your database) and control things like the 
admin username/password, blog title, etc. You can modify the value of system 
settings but you can't delete them.

User settings are a way for you to define arbitrary strings that you can use in 
your templates. With user settings, you can sprinkle bits of managed content 
throughout your templates and update it without having to deploy a new build of 
your site or edit multiple files.

Settings are available to your templates through the @settings hash. Settings 
are nested into hashes by splitting the key on the period (dot) character. 
System settings are in @settings[:system] and any user settings you add will be 
in @settings[:user].

So, for example, your admin username has the key "admin.user" and since it is a 
system setting it will be available to your templates as 
"@settings[:system][:admin][:user]". If you added a user setting with the key 
"youtube.url", it would be available as "@settings[:user][:youtube][:url]".

## Questions?

Feel free to [email me](mailto:jesse.c.scott@gmail.com)!
