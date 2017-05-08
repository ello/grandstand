require 'retries'
require 'work_queue'
require 'logger'

namespace :impressions do
  desc 'Update UUID column for all impressions'
  task :update_all_uuids => :environment do
    Date.new(2016, 12, 16).upto(Date.today) do |date|
      logger.info("*** Updating date: #{date.strftime("%Y/%m/%d")} ***")
      Impression
      .where(uuid: nil)
      .where(created_at: (date.beginning_of_day..date.end_of_day))
      .update_all("uuid = uuid_generate_v4()")
    end
  end

  desc 'Update UUID column and upload to S3'
  task :upload_to_s3 => :environment do
    Date.new(2016, 12, 16).upto(Date.today) do |date|
      impressions = Impression.where(created_at: (date.beginning_of_day..date.end_of_day))
      queue.enqueue_b do
        with_retries(max_tries: 10) do
          impressions.each do |impression|
            imp = format_for_s3(impression)
            logger.info("***#{date.strftime("%Y/%m/%d")}*** --- uploading file #{impression.uuid}")
            S3Client.upload(filename: "#{viewed_at(imp)}/#{uuid(imp)}}",
                            body:     imp.to_json)
          end
        end
      end
    end
    queue.join
  end

  def queue
    @queue ||= WorkQueue.new(100)
  end

  def format_for_s3(impression)
    {
      id: impression.id,
      author: { id: impression.author_id },
      viewer: { id: impression.viewer_id },
      post: { id: impression.post_id },
      stream_kind: impression.stream_kind,
      stream_id: impression.stream_id,
      uuid: impression.uuid,
      created_at: impression.created_at
    }
  end

  def viewed_at(impression)
    impression[:created_at].strftime("%Y/%m/%d")
  end

  def uuid(impression)
    impression[:uuid]
  end

  def logger
    @logger ||= Logger.new(STDERR)
  end
end
