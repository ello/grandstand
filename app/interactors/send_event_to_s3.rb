class SendEventToS3
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  # ** Uploading historical data **
  #
  # - Create rake task that will rip through a particular time period (per day?), use Postgres'
  # UUID function to update_all (may need to enable extension), and then store it on S3. Look into batch
  # uploads for S3.
  # - Be sure to replicate event format that we get from mothership (don't have to include fields that aren't in DB for user/post data, id is fine)

  def call
    S3Client.upload(filename: "#{viewed_at}/#{uuid}}",
                    body:     context.record)
  end
  add_transaction_tracer :call, category: :task

  private

  def viewed_at
    epoch = context.record['viewed_at'].to_f
    Time.at(epoch).strftime("%Y/%m/%d")
  end

  def uuid
    context.record['uuid']
  end
end
