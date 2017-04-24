class UserHourlyImpression < AggregationRecord

  class << self
    def create_or_update(attrs)
      where(
        starting_at: attrs[:starting_at],
        author_id:   attrs[:author_id],
      ).first_or_initialize.update!(
        views:       attrs[:views],
      )
    end
  end
end
