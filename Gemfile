source 'http://rubygems.org'

gem 'rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

group :development do
  gem 'unicorn'
  gem 'sqlite3'
  gem 'rspec-rails'
end

group :test do
  gem 'turn', :require => false
  gem 'rspec-rails'
  #gem 'capybara'
  gem 'factory_girl_rails'
end

group :production do
  gem 'pg'
  gem 'unicorn'
end

gem 'execjs'
gem 'therubyracer'

gem 'mogli'
gem 'ruby-hmac'
gem 'facebooker2'