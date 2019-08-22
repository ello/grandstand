class ArtistInviteHourlyImpression < AggregationRecord
  class << self
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
      san_start_date = ActiveRecord::Base::sanitize_sql(start_date)
      san_end_date = ActiveRecord::Base::sanitize_sql(end_date)
      san_artist_invite_id = ActiveRecord::Base::sanitize_sql(artist_invite_id)

      AggregationRecord.connection.execute(%Q{
      SELECT
        t.artist_invite_id as "artist_invite_id",
        date(t.starting_at) as "date",
        sum(t.logged_out_views) + sum(t.logged_in_views) as "impressions",
        null as "stream_kind"
      FROM
        artist_invite_hourly_impressions t
      WHERE
        t.starting_at >= #{san_start_date} AND t.starting_at <= #{san_end_date}
        AND t.artist_invite_id = #{san_artist_invite_id}
      GROUP BY
        date(t.starting_at),
        t.artist_invite_id
      ORDER BY
        date(starting_at) ASC;}).to_a
    end

    def total_aggregation(artist_invite_id)
      san_artist_invite_id = ActiveRecord::Base::sanitize_sql(artist_invite_id)

      AggregationRecord.connection.execute(%Q{
      SELECT
        t.artist_invite_id as "artist_invite_id",
        sum(t.logged_out_views) + sum(t.logged_in_views) as "impressions",
        null as "stream_kind"
      FROM
        artist_invite_hourly_impressions t
      WHERE
        t.artist_invite_id = #{san_artist_invite_id}
      GROUP BY
        t.artist_invite_id;}).to_a
    end
  end
end
