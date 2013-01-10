source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'tabs_on_rails', "~> 2.1.1"
gem 'jquery-rails'
gem 'devise'
gem 'simple_form'
gem 'rails-settings', :git => 'git://github.com/100hz/rails-settings.git'
gem 'kaminari'
gem 'cancan'
gem 'nested_form', :git => 'git://github.com/ryanb/nested_form.git'
gem 'faker'
gem "watu_table_builder", :require => "table_builder", :git => "git://github.com/watu/table_builder.git"
gem 'rails-settings', :git => 'git://github.com/100hz/rails-settings.git'
gem 'roadie'
gem 'pg_search'
gem 'pdfkit'
gem "paperclip"
gem 'capistrano'
gem 'unicorn'
gem 'whenever', :require => false
gem 'prawn', :git => "git://github.com/prawnpdf/prawn.git"

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

group :development do
  gem 'letter_opener'
  gem 'guard'
  gem 'quiet_assets'
  gem 'thin'
end

group :development, :test do
  gem 'debugger'
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'simplecov', :require => false
  gem 'hirb'
end

group :production do
  gem 'exception_notification'
end