source 'https://rubygems.org'

gem 'rails', '~> 3.2.8'

gem 'sqlite3', '~> 1.3.6'
gem 'redcarpet', '~> 2.1.1'
gem 'factory_girl_rails', '~> 4.1.0'

group :development do
  gem 'thin'
end

group :test, :development do
  gem 'rspec-rails', '~> 2.11'
  gem 'capybara', '~> 1.1.2'
end

group :test do
  gem 'simplecov', '~> 0.6.4', :require => false
  gem 'shoulda-matchers', '~> 1.4.0'
  gem 'database_cleaner', '~> 0.8.0'
  gem 'faker', '~> 1.1.2'
  gem 'launchy'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
end

group :production do
	gem 'uglifier', "~> 1.2.3"
end

gem 'jquery-rails'

# Deploy with Capistrano
# (See 'Capfile.example' and 'config/deploy.rb.example' for Capistrano deployment.)
gem 'capistrano'

# If your server uses RVM, uncomment this as well.
gem 'rvm-capistrano'