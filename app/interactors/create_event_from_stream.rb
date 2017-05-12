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
        impression = Impression.create!(author_id: record.dig('author', 'id'),
                                        viewer_id: record.dig('viewer', 'id'),
                                        post_id: record.dig('post', 'id'),
                                        stream_kind: record['stream_kind'],
                                        stream_id: record['stream_id'],
                                        uuid: record['uuid'],
                                        created_at: Time.at(record['viewed_at']))

        S3Client.upload(filename: "#{s3_path(impression)}/#{impression.uuid}",
                        body:     impression.to_json)
      end
    rescue ActiveRecord::RecordNotUnique => e
      context.fail!(error: e)
    end
  end
  add_transaction_tracer :post_was_viewed, category: :task

  def s3_path(impression)
    S3Client.path_for_impression(impression)
  end
end
