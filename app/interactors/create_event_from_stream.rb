class CreateEventFromStream
  include Interactor

  def call
    if respond_to?(context.kind, true)
      send(context.kind, context.record)
    end
  end

  private

  def post_was_viewed(record)
    begin
      Impression.create!(author_id: record.dig('author', 'id'),
                        viewer_id: record.dig('viewer', 'id'),
                        post_id: record.dig('post', 'id'),
                        created_at: Time.at(record['viewed_at']))
    rescue ActiveRecord::RecordNotUnique => e
      context.fail!(error: e)
    end
  end
end
