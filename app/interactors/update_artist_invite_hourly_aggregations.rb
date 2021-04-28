# frozen_string_literal: true

class UpdateArtistInviteHourlyAggregations
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    (start_of_day...end_of_day).step(1.hour).each do |hour|
      start_of_hour = Time.at(hour).utc
      end_of_hour = start_of_hour.end_of_hour
      update_between(start_of_hour, end_of_hour)
    end
  end

  private

  def update_between(start, finish)
    query = Impression.between(start, finish).where.not(artist_invite_id: nil)

    track_views(start, query)
  end

  def track_views(start, query)
    views(query).each do |invite_id, stream_counts|
      stream_counts.each do |stream_kind, counts|
        ArtistInviteHourlyImpression.create_or_update(
          artist_invite_id: invite_id,
          starting_at: start,
          stream_kind: stream_kind,
          logged_in_views: counts[:logged_in_views],
          logged_out_views: counts[:logged_out_views]
        )
      end
    end
  end

  def views(query)
    query
      .group(:artist_invite_id, :stream_kind, 'viewer_id IS NOT NULL')
      .count
      .each_with_object({}) do |(k, count), views|
        invite_id   = k[0]
        stream_kind = k[1]
        logged_in   = k[2]
        views[invite_id] ||= {}
        views[invite_id][stream_kind] ||= {}
        if logged_in
          views[invite_id][stream_kind][:logged_in_views] = count
        else
          views[invite_id][stream_kind][:logged_out_views] = count
        end
      end
  end

  def start_of_day
    context.date.beginning_of_day.utc.to_i
  end

  def end_of_day
    context.date.end_of_day.utc.to_i
  end

  add_transaction_tracer :call, category: :task
end
