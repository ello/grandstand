# frozen_string_literal: true

task spec: ['aggregation:db:test:prepare']

namespace :aggregation do

  namespace :db do |ns|

    task drop: :environment do
      Rake::Task['db:drop'].invoke
    end

    task create: :environment do
      Rake::Task['db:create'].invoke
    end

    task setup: :environment do
      Rake::Task['db:setup'].invoke
    end

    task migrate: :environment do
      Rake::Task['db:migrate'].invoke
    end

    task rollback: :environment do
      Rake::Task['db:rollback'].invoke
    end

    task seed: :environment do
      Rake::Task['db:seed'].invoke
    end

    task version: :environment do
      Rake::Task['db:version'].invoke
    end

    namespace :schema do
      task load: :environment do
        Rake::Task['db:schema:load'].invoke
      end

      task dump: :environment do
        Rake::Task['db:schema:dump'].invoke
      end
    end

    namespace :test do
      task prepare: :environment do
        Rake::Task['db:test:prepare'].invoke
      end
    end

    # append and prepend proper tasks to all the tasks defined here above
    ns.tasks.each do |task|
      task.enhance ['aggregation:set_custom_config'] do
        Rake::Task['aggregation:revert_to_original_config'].invoke
      end
    end
  end

  task set_custom_config: :environment do
    # save current vars
    @original_config = {
      env_schema: ENV['SCHEMA'],
      config: Rails.application.config.dup
    }

    # set config variables for custom database
    ENV['SCHEMA'] = 'aggregation_db/structure.sql'
    Rails.application.config.paths['db'] = ['aggregation_db']
    Rails.application.config.paths['db/migrate'] = ['aggregation_db/migrate']
    Rails.application.config.paths['db/seeds'] = ['aggregation_db/seeds.rb']
    Rails.application.config.paths['config/database'] = ['config/aggregation_database.yml']
  end

  task revert_to_original_config: :environment do
    # reset config variables to original values
    ENV['SCHEMA'] = @original_config[:env_schema]
    Rails.application.config = @original_config[:config]
  end
end
