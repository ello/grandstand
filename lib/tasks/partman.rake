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

    task :archive_partition => :environment do
      partition_name = ENV['PARTITION_NAME'] || raise('Must specify PARTITION_NAME')
      s3_bucket = ENV['S3_BUCKET'] || raise('Must specify S3_BUCKET')

      Tempfile.create(partition_name) do |f|
        puts "Starting copy operation..."
        conn = ActiveRecord::Base.connection.raw_connection
        conn.copy_data "COPY #{partition_name} TO STDOUT CSV HEADER" do
          while row = conn.get_copy_data
          f.puts row.force_encoding(conn.internal_encoding)
          end
        end

        f.rewind

        puts "Starting upload operation..."
        s3 = Aws::S3::Client.new
        resp = s3.put_object({
          body: f,
          bucket: s3_bucket,
          key: "#{partition_name}.csv",
          server_side_encryption: "AES256"
        })

        puts resp
      end

    end
  end
end
