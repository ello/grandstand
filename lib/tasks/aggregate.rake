namespace :aggregate do
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
end
