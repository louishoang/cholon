source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use mysql2 as the database for Active Record
gem 'mysql2', '~> 0.3.18'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'bootstrap-sass', '~> 3.3.5'
gem "font-awesome-rails"

#authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

#authorization
gem "pundit"

#upload-storage
gem "paperclip", "~> 4.3"
gem 'rmagick', '~> 2.15.3'
gem "fog"
gem "fog-aws"
gem 'aws-sdk', '~> 1.6'

#form validator
gem 'jquery-form-validator-rails', :git => "https://github.com/louishoang/jquery-form-validator-rails.git"
# pretty url
gem 'friendly_id'
# pagination
gem 'kaminari'

# html editor
gem 'tinymce-rails'
gem 'tinymce-rails-langs'

#shipping cost calculator
gem 'active_shipping'
# location to coordinate
gem 'geocoder'

#search engine
gem 'sunspot_rails'

# Typeahead gem
gem 'bootstrap-typeahead-rails'

#app server
gem 'puma'

#payment
gem "braintree"


group :development do
  gem 'rack-mini-profiler'
  gem 'brakeman', :require => false #security vulnerable detector
  gem 'sunspot_solr'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem "launchy"
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem "factory_girl_rails"
  gem "capybara"
  gem "faker"
  gem 'pry-rails'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

