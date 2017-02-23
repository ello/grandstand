namespace :credentials do
  desc 'Updates the database credentials for mothership foreign tables'
  # Run this task without spaces between the args, in the following format:
  # rake credentials:update[arg1,arg2..]

  task :update, [:host, :dbname, :user, :password] => :environment do |t, args|
    # This SQL query requires psql version 9.5 or higher
    sql = "BEGIN;
          CREATE EXTENSION IF NOT EXISTS postgres_fdw;
          DROP SERVER IF EXISTS mothership_database_server CASCADE;
          CREATE SERVER mothership_database_server
          FOREIGN DATA WRAPPER postgres_fdw
          OPTIONS (host '#{args.host}', dbname '#{args.dbname}');
          CREATE USER MAPPING FOR CURRENT_USER
          SERVER mothership_database_server
          OPTIONS (user '#{args.user}', password '#{args.password}');
          DROP SCHEMA IF EXISTS app;
          CREATE SCHEMA app;
          IMPORT FOREIGN SCHEMA public
          FROM SERVER mothership_database_server
          INTO app;
          COMMIT;"

    ActiveRecord::Base.connection.execute(sql)
  end
end