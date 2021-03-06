# frozen_string_literal: true

class UpdateDailyEmailActiveUserRollups
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    mau = EmailActiveUserRollup.where(day: context.date).first_or_initialize
    mau.day_total        = day_total
    mau.thirty_day_total = rolling_total
    mau.save
  end

  private

  def rolling_total
    Impression.between(start_of_period, end_of_period)
              .where(stream_kind: 'email')
              .where.not(viewer_id: nil)
              .distinct(:viewer_id)
              .count(:viewer_id)
  end

  def day_total
    Impression.between(start_of_day, end_of_day)
              .where(stream_kind: 'email')
              .where.not(viewer_id: nil)
              .distinct(:viewer_id)
              .count(:viewer_id)
  end

  def start_of_period
    (context.date - 30.days).beginning_of_day.utc
  end

  def end_of_period
    context.date.end_of_day.utc
  end

  def start_of_day
    context.date.beginning_of_day.utc
  end

  def end_of_day
    context.date.end_of_day.utc
  end
end
