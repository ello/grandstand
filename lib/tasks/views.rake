namespace :views do
  task refresh: :environment do
    Scenic.database.refresh_materialized_view('impressions_by_days', concurrently: true)
    Scenic.database.refresh_materialized_view('impressions_by_author_by_days', concurrently: true)
    Scenic.database.refresh_materialized_view('impressions_by_post_by_days', concurrently: true)
  end
end
