# frozen_string_literal: true

class RemoveAggregatedUser
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    return unless (user = AggregatedUser.get(context.username))

    UserHourlyAggregations.where(author_id: user.id).destroy_all if context.purge
    AggregatedUser.remove(context.username)
  end
end
