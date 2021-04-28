# frozen_string_literal: true

namespace :kinesis do
  desc 'Parses and saves events from Kinesis queue'
  task consumer: :environment do
    # Production eager loading doesn't happen in Rake tasks
    # We need to force it here since the consuemr is threaded
    Rails.application.eager_load!

    stream = StreamReader.new(
      stream_name: ENV['KINESIS_STREAM_NAME'],
      prefix: ENV['KINESIS_STREAM_PREFIX'] || ''
    )

    stream.run! do |record, opts|
      CreateEventFromStream.call(record: record, kind: opts[:schema_name].underscore)
    end
  end
end
