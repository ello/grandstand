namespace :views do
  task refresh: :environment do
    Scenic.database.refresh_materialized_view('impressions_by_days', concurrently: true)
    Scenic.database.refresh_materialized_view('impressions_by_stream_by_day', concurrently: true)
    Scenic.database.refresh_materialized_view('impressions_by_category_by_days', concurrently: true)
    Scenic.database.refresh_materialized_view('impressions_by_email_by_days', concurrently: true)
  end
end
