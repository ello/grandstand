class AddAggregatedUser
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    user = AggregatedUser.add(context.id, context.username)
    if context.backfill
      (90.days.ago.to_date..Date.today).each do |date|
        #UpdateUserHourlyAggregations.call(user_id: user.id, date: date)
      end
    end
  end
end
