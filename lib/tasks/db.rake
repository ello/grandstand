namespace :db do
  task :migrate_all do
    Rake::Task['db:migrate'].invoke
    Rake::Task['aggregation:db:migrate'].invoke
  end

  namespace :test do
    task :prepare_all do
      Rake::Task['db:test:prepare'].invoke
      Rake::Task['aggregation:db:test:prepare'].invoke
    end
  end
end
