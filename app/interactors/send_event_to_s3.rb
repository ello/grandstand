class SendEventToS3
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  require_relative '../../lib/api_clients/s3_client'

  # Save filename as UUID
  # Upload historical data already in the impressions table
  def call
    S3Client.upload(filename: "#{viewed_at}/#{shard_id}/#{uuid}}",
                    body:     context.record)
  end

  private

  def viewed_at
    epoch = context.record['viewed_at'].to_f
    Time.at(epoch).strftime("%Y/%m/%d")
  end

  def shard_id
    context.opts[:shard_id]
  end

  def uuid
    context.record['uuid']
  end

  add_transaction_tracer :call, category: :task
end
