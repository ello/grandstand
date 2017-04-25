class RemoveAggregatedUser
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    if user = AggregatedUser.get(context.username)
      if context.purge
        UserHourlyAggregations.where(author_id: user.id).destroy_all
      end
      AggregatedUser.remove(context.username)
    end
  end
end
