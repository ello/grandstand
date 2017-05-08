class SendEventToS3
  include Interactor
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def call
    S3Client.upload(filename: "#{viewed_at}/#{uuid}",
                    body:     context.record.to_json)
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
