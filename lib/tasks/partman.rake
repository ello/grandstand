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

    task :archive_old_partitions => :environment do
      all_partitions = ActiveRecord::Migration.execute("SELECT partman.show_partitions('public.impressions')").
        to_a.
        map { |r| r['show_partitions'].split(',')[1].gsub(')', '') }.
        sort.
        reverse.
        take(10) # limit to keep task run time down.

      all_partitions.each do |partition_name|
        parsed = /impressions_p(\d{4})_(\d{2})_(\d{2})/.match(partition_name)
        partition_date = Date.new(parsed[1].to_i, parsed[2].to_i, parsed[3].to_i)

        if partition_date < 180.days.ago
          puts "Archiving #{partition_name}"
          Rake::Task['db:partman:archive_partition'].invoke(partition_name)
          Rake::Task['db:partman:archive_partition'].reenable
          days_old = (Date.today - partition_date).to_i
          puts "Removing partitions older then #{days_old} days old"
          # Rake::Task['db:partman:delete_partitions'].invoke(days_old)
          # Rake::Task['db:partman:delete_partitions'].reenable
        end
      end
    end

    task :delete_partitions, [:older_than] => :environment do |t, args|
      older_than = args[:older_than].try(:to_i) || raise('Must specify older_than (in days)')
      raise 'Partition too young to delete!' unless older_than > 180

      resp = ActiveRecord::Migration.execute("SELECT partman.drop_partition_time('public.impressions', '#{older_than} days', FALSE, FALSE)")
      puts resp[0]
    end

    task :archive_partition, [:partition_name] => :environment do |t, args|
      partition_name = args[:partition_name] || raise('Must specify partition_name')
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
