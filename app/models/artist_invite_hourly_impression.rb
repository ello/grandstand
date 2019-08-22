class ArtistInviteHourlyImpression < AggregationRecord
  class << self
    extend ActiveRecord::Sanitization::ClassMethods

    def create_or_update(attrs)
      where(
        artist_invite_id: attrs[:artist_invite_id],
        starting_at:      attrs[:starting_at],
        stream_kind:      attrs[:stream_kind],
      ).first_or_initialize.update!(
        logged_in_views:  (attrs[:logged_in_views] || 0),
        logged_out_views: (attrs[:logged_out_views] || 0),
      )
    end

    def daily_aggregation(start_date, end_date, artist_invite_id)
      sanitized_query = sanitize_sql([
        "t.starting_at >= ? AND t.starting_at <= ? AND t.artist_invite_id = ?",
        start_date, end_date, artist_invite_id
      ])

      AggregationRecord.connection.execute(%Q{
      SELECT
        t.artist_invite_id as "artist_invite_id",
        date(t.starting_at) as "date",
        sum(t.logged_out_views) + sum(t.logged_in_views) as "impressions",
        null as "stream_kind"
      FROM
        artist_invite_hourly_impressions t
      WHERE
        #{sanitized_query}
      GROUP BY
        date(t.starting_at),
        t.artist_invite_id
      ORDER BY
        date(starting_at) ASC;}).to_a
    end

    def total_aggregation(artist_invite_id)
      sanitized_query = sanitize_sql(["t.artist_invite_id = ?", artist_invite_id])

      AggregationRecord.connection.execute(%Q{
      SELECT
        t.artist_invite_id as "artist_invite_id",
        sum(t.logged_out_views) + sum(t.logged_in_views) as "impressions",
        null as "stream_kind"
      FROM
        artist_invite_hourly_impressions t
      WHERE
        #{sanitized_query}
      GROUP BY
        t.artist_invite_id;}).to_a
    end
  end
end
