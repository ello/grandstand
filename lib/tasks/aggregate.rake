namespace :aggregate do
  namespace :email_mau do
    desc "Update EmailActiveUserRollup records for each day in all history"
    task all: :environment do
      Rails.logger.level = :info
      current = Impression.first.created_at.to_date
      while current <= Date.today
        Rails.logger.info "Aggregating Email Users for #{current}"
        UpdateDailyEmailActiveUserRollups.call(date: current)
        current = current + 1.day
      end
    end

    desc "Update EmailActiveUserRollup records for each day in given month"
    task :for_month, [:year, :month] => :environment do |t, args|
      Rails.logger.level = :info
      year = args[:year].to_i
      month = args[:month].to_i
      current = Date.new(year, month, 1)
      while current <= Date.new(year, month).end_of_month
        Rails.logger.info "Aggregating Email Users for #{current}"
        UpdateDailyEmailActiveUserRollups.call(date: current)
        current = current + 1.day
      end
    end

    desc "Update EmailActiveUserRollup records for today"
    task today: :environment do
      UpdateDailyEmailActiveUserRollups.call(date: Date.today)
    end

    desc "Update EmailActiveUserRollup records for yesterday"
    task yesterday: :environment do
      UpdateDailyEmailActiveUserRollups.call(date: Date.yesterday)
    end
  end

  namespace :hourly do
    desc "Aggregate hourly impressions for every impression every recorded."
    task all: :environment do
      Rails.logger.level = :info
      current = Impression.first.created_at.to_date
      while current <= Date.today
        Rails.logger.info "Aggregating Hourly Impressions for #{current}"
        UpdateHourlyAggregations.call(date: current)
        current = current + 1.day
      end
    end

    desc "Aggregate hourly impressions for every impression in the given year and month."
    task :for_month, [:year, :month] => :environment do |t, args|
      Rails.logger.level = :info
      year = args[:year].to_i
      month = args[:month].to_i
      current = Date.new(year, month, 1)
      while current <= Date.new(year, month).end_of_month
        Rails.logger.info "Aggregating Hourly Impressions for #{current}"
        UpdateHourlyAggregations.call(date: current)
        current = current + 1.day
      end
    end

    desc "Aggregate hourly impressions for all of todays impressions."
    task today: :environment do
      UpdateHourlyAggregations.call(date: Date.today)
    end

    desc "Aggregate hourly impressions for all of yesterdays impressions."
    task yesterday: :environment do
      UpdateHourlyAggregations.call(date: Date.yesterday)
    end
  end

  namespace :user_hourly do
    desc "Aggregate hourly impressions for impression ever recorded for aggregated authors."
    task all: :environment do
      Rails.logger.level = :info
      current = Impression.first.created_at.to_date
      users = AggregatedUser.all
      while current <= Date.today
        users.each do |user|
          Rails.logger.info "Aggregating Hourly Impressions for #{user.username} on #{current}"
          UpdateUserHourlyAggregations.call(date: current, author_id: user.id)
        end
        current = current + 1.day
      end
    end

    desc "Aggregate hourly impressions for every impression in the given year and month."
    task :for_month, [:year, :month] => :environment do |t, args|
      Rails.logger.level = :info
      year = args[:year].to_i
      month = args[:month].to_i
      current = Date.new(year, month, 1)
      users = AggregatedUser.all
      while current <= Date.new(year, month).end_of_month
        users.each do |user|
          Rails.logger.info "Aggregating Hourly Impressions for #{user.username} on #{current}"
          UpdateUserHourlyAggregations.call(date: current, author_id: user.id)
        end
        current = current + 1.day
      end
    end

    desc "Aggregate hourly impressions for all of todays impressions."
    task today: :environment do
      AggregatedUser.all.each do |user|
        Rails.logger.info "Aggregating Hourly Impressions for #{user.username} for today"
        UpdateUserHourlyAggregations.call(date: Date.today, author_id: user.id)
      end
    end

    desc "Aggregate hourly impressions for all of yesterdays impressions."
    task yesterday: :environment do
      AggregatedUser.all.each do |user|
        Rails.logger.info "Aggregating Hourly Impressions for #{user.username} for yesterday"
        UpdateUserHourlyAggregations.call(date: Date.yesterday, author_id: user.id)
      end
    end
  end

  task :today do
    Rake::Task['aggregate:hourly:today'].invoke
    Rake::Task['aggregate:user_hourly:today'].invoke
    Rake::Task['aggregate:email_mau:today'].invoke
  end

  task :yesterday do
    Rake::Task['aggregate:hourly:yesterday'].invoke
    Rake::Task['aggregate:user_hourly:yesterday'].invoke
    Rake::Task['aggregate:email_mau:yesterday'].invoke
  end
end
