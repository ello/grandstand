namespace :views do
  task refresh: :environment do
    Scenic.database.refresh_materialized_view('impressions_by_days', concurrently: false)
  end
end
