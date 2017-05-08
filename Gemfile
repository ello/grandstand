source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'

gem 'kinesis-stream-reader', require: 'stream_reader', github: 'ello/kinesis-stream-reader'

gem 'interactor-rails'
gem 'dotenv-rails'
gem 'newrelic_rpm'
gem 'aws-sdk', '~> 2'
gem 'work_queue'
gem 'retries'

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'rspec-rails-time-metadata'
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'danger'
end

group :production do
  gem 'rails_12factor'
  gem 'honeybadger', '~> 2.0'
end
