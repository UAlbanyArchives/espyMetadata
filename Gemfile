source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'pg', '0.20'
gem 'sequel'
# Use Puma as the app server
gem 'puma', '~> 3.12.6'
# Use Passenger for production (insalled with YUM instead)
#gem 'passenger'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# bootstrap/styling
#gem 'bootstrap', '~> 4.0.0.beta'
gem 'sprockets-rails', '>= 2.3.2', :require => 'sprockets/railtie'
gem 'font-awesome-rails'

# jquery
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 6.0.1'

#redis for autocomplete
gem 'redis', '~> 3.0.7'
gem 'listen', '>= 3.0.5', '< 3.2'

gem 'devise'
gem 'devise-bootstrap-views', '~> 1.0'
gem 'httparty'
gem 'http'

# dependency gems updated for issues
gem 'nokogiri', '~> 1.10.5'
gem "loofah", "~> 2.3.1"
gem "rubyzip", "~> 1.3.0"
gem "rails-html-sanitizer", "~> 1.3.0"
gem "sprockets", "~> 3.7.2"
gem "ffi", "~> 1.11.1"
gem "bootstrap", "~> 4.3.1"
gem "rack", "~> 2.1.4"
gem "websocket-extensions", ">= 0.1.5"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
