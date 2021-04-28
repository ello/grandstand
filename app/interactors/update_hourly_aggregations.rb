# frozen_string_literal: true

class UpdateHourlyAggregations
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
    query = Impression.between(start, finish)

    track_category_views(start, query)
    track_stream_views(start, query)
    track_unknown_views(start, query)
  end

  # Stream_id matters in category views
  def track_category_views(start, query)
    category_views(query).each do |stream_id, counts|
      HourlyImpression.create_or_update(
        starting_at: start,
        stream_kind: 'category',
        stream_id: stream_id,
        logged_in_views: counts[:logged_in_views],
        logged_out_views: counts[:logged_out_views]
      )
    end
  end

  def category_views(query)
    query
      .where(stream_kind: 'category')
      .group(:stream_id, 'viewer_id IS NOT NULL')
      .count
      .each_with_object({}) do |(k, count), views|
        stream_id = k[0]
        logged_in = k[1]
        views[stream_id] ||= {}
        if logged_in
          views[stream_id][:logged_in_views] = count
        else
          views[stream_id][:logged_out_views] = count
        end
      end
  end

  def track_stream_views(start, query)
    stream_views(query).each do |stream_kind, counts|
      HourlyImpression.create_or_update(
        starting_at: start,
        stream_kind: stream_kind,
        logged_in_views: counts[:logged_in_views],
        logged_out_views: counts[:logged_out_views]
      )
    end
  end

  def stream_views(query)
    query
      .where.not(stream_kind: 'category')
      .group(:stream_kind, 'viewer_id IS NOT NULL')
      .count
      .each_with_object({}) do |(k, count), views|
        stream_kind = k[0]
        logged_in   = k[1]
        views[stream_kind] ||= {}
        if logged_in
          views[stream_kind][:logged_in_views] = count
        else
          views[stream_kind][:logged_out_views] = count
        end
      end
  end

  def track_unknown_views(start, query)
    unknown_views(query).each do |stream_kind, counts|
      HourlyImpression.create_or_update(
        starting_at: start,
        stream_kind: stream_kind,
        logged_in_views: counts[:logged_in_views],
        logged_out_views: counts[:logged_out_views]
      )
    end
  end

  def unknown_views(query)
    query
      .where(stream_kind: nil)
      .group('viewer_id IS NOT NULL')
      .count
      .each_with_object({}) do |(k, count), views|
        logged_in   = k
        stream_kind = 'unknown'
        views[stream_kind] ||= {}
        if logged_in
          views[stream_kind][:logged_in_views] = count
        else
          views[stream_kind][:logged_out_views] = count
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
