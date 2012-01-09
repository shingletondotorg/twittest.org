source 'http://rubygems.org'

gem 'rails', '3.0.9'
gem "profanity_filter"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', '1.2.5', :require => 'sqlite3'
gem 'gravatar_image_tag'
gem 'will_paginate', '>= 3.0.pre'
gem 'rake',  '0.9.2'

group :development do
  # rspec-rails for Rspec-specific generators (rails generate)
  gem 'rspec-rails', '2.0.0.beta.18'
  gem 'annotate'
  gem 'faker', '0.3.1'
  gem 'capistrano'
end

group :test do
  # rspec in :test group for actually running tests
  gem 'rspec', '2.0.0.beta.18'
  # Speeds up rspec
  gem 'spork', '0.8.4'
  gem 'factory_girl_rails', '1.0'
  if RUBY_PLATFORM =~ /darwin/
    gem 'autotest-growl'
    gem 'autotest-fsevent'
  end
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
