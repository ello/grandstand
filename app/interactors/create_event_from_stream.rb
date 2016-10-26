class CreateEventFromStream
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    if respond_to?(context.kind, true)
      send(context.kind, context.record)
    end
  end

  private

  def post_was_viewed(record)
    begin
      Impression.skip_transaction do
        Impression.create!(author_id: record.dig('author', 'id'),
                          viewer_id: record.dig('viewer', 'id'),
                          post_id: record.dig('post', 'id'),
                          created_at: Time.at(record['viewed_at']))
      end
    rescue ActiveRecord::RecordNotUnique => e
      context.fail!(error: e)
    end
  end
  add_transaction_tracer :post_was_viewed, category: :task
end
