# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.3'

gem 'bundler', '2.0.2'
gem 'nokogiri', '>= 1.10.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2', '>= 5.2.0'

gem 'kinesis-stream-reader', require: 'stream_reader', github: 'ello/kinesis-stream-reader'

gem 'dotenv-rails'
gem 'interactor-rails'
gem 'newrelic_rpm'

gem 'aws-sdk'

group :development, :test do
  gem 'database_cleaner'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rspec-rails-time-metadata'
  gem 'shoulda-matchers'
end

group :development do
  gem 'danger'
  gem 'listen', '~> 3.0.5'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :production do
  gem 'honeybadger', '~> 2.0'
  gem 'rails_12factor'
end
