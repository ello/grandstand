namespace :db do
  namespace :partman do
    task :compile do
      PARTMAN_VERSION = '2.6.2'.freeze

      sh "curl -L -O https://github.com/keithf4/pg_partman/archive/v#{PARTMAN_VERSION}.tar.gz"
      sh "tar -zxvf v#{PARTMAN_VERSION}.tar.gz"
      sh "cd pg_partman-#{PARTMAN_VERSION} && make NO_BGW=1 install"
    end

    task :run_maintenance => :environment do
      ActiveRecord::Migration.execute 'SELECT partman.run_maintenance()'
    end

    task :partition_data => :environment do
      result = nil
      while result!= 0
        result = ActiveRecord::Migration.execute("SELECT partman.partition_data_time('public.impressions')")[0]['partition_data_time']
      end
    end
  end
end
