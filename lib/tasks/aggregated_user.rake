namespace :aggregated_user do

  desc "Add aggregated user by id and username"
  task :add, [:id, :username] => :environment do |t, args|
    AddAggregatedUser.call(
      id:       args[:id].to_i,
      username: args[:username],
      backfill: false,
    )
  end

  desc "Add aggregated user by id and username and backfill views aggregations 3 months"
  task :add_and_backfill, [:id, :username] => :environment do |t, args|
    AddAggregatedUser.call(
      id:       args[:id].to_i,
      username: args[:username],
      backfill: true,
    )
  end

  desc "Remove aggregated user by id and username - post views will be kept"
  task :remove, [:username] => :environment do |t, args|
    RemoveAggregatedUser.call(
      username: args[:username],
      purge:    false,
    )
  end

  desc "Remove aggregated user by id and username - aggregated post views will be removed"
  task :remove_and_purge, [:username] => :environment do |t, args|
    RemoveAggregatedUser.call(
      username: args[:username],
      purge:    true,
    )
  end

  desc "List aggregated users"
  task list: :environment do
    AggregatedUser.all.each do |user|
      puts "#{user.id} - #{user.username}"
    end
  end
end
