# frozen_string_literal: true

class UpdateUserHourlyAggregations
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
    count = Impression
            .between(start, finish)
            .where(author_id: author_id)
            .count

    UserHourlyImpression.create_or_update(
      starting_at: start,
      author_id: author_id,
      views: count
    )
  end

  def start_of_day
    context.date.beginning_of_day.utc.to_i
  end

  def end_of_day
    context.date.end_of_day.utc.to_i
  end

  def author_id
    context.author_id
  end

  add_transaction_tracer :call, category: :task
end
