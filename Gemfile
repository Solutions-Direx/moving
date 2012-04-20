source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'rmagick'
gem 'carrierwave'
gem 'tabs_on_rails', "~> 2.1.1"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby
end

gem 'jquery-rails'
gem 'devise'
gem 'simple_form'
gem 'rails-settings', :git => 'git://github.com/100hz/rails-settings.git'
gem 'kaminari'
gem 'cancan'
gem 'nested_form', :git => 'git://github.com/ryanb/nested_form.git'
gem 'heroku'
gem 'faker'
gem "watu_table_builder", :require => "table_builder", :git => "git://github.com/watu/table_builder.git"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development do
  gem 'letter_opener'
  gem 'guard'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'debugger'
end

group :test do
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'simplecov', :require => false
end

group :production do
  gem 'pg'
end