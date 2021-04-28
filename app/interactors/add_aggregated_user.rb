# frozen_string_literal: true

class AddAggregatedUser
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    user = AggregatedUser.add(context.id, context.username)

    return unless context.backfill

    (90.days.ago.to_date..Time.zone.today).each do |date|
      UpdateUserHourlyAggregations.call(author_id: user.id, date: date)
    end
  end
end
