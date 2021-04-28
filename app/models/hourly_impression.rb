# frozen_string_literal: true

class HourlyImpression < AggregationRecord

  class << self
    def create_or_update(attrs)
      query = where(
        starting_at: attrs[:starting_at],
        stream_kind: attrs[:stream_kind]
      )
      query = query.where(stream_id: attrs[:stream_id]) if attrs[:stream_id]

      query.first_or_initialize.update!(
        logged_in_views: (attrs[:logged_in_views] || 0),
        logged_out_views: (attrs[:logged_out_views] || 0)
      )
    end
  end
end
