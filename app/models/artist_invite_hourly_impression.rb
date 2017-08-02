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
  end
end
