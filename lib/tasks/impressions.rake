require 'retries'
require 'work_queue'

namespace :impressions do
  desc 'Update UUID column for all impressions'
  task :update_all_uuids => :environment do
    Date.new(2016, 12, 16).upto(Date.today) do |date|
      logger.debug("*** Updating date: #{date.strftime("%Y/%m/%d")} ***")
      Impression
      .where(uuid: nil)
      .where(created_at: (date.beginning_of_day..date.end_of_day))
      .update_all("uuid = uuid_generate_v4()")
    end
  end

  desc 'Update UUID column and upload to S3'
  task :upload_to_s3 => :environment do
    queue = WorkQueue.new(100)
    Date.new(2016, 12, 16).upto(Date.today) do |date|
      impressions = Impression.where(created_at: (date.beginning_of_day..date.end_of_day))
      queue.enqueue_b do
        with_retries(max_tries: 10) do
          impressions.each do |impression|
            logger.debug("***#{s3_path(impression)}*** --- uploading file #{impression.uuid}")
            S3Client.upload(filename: "#{s3_path(impression)}/#{impression.uuid}}",
                            body:     impression.to_json)
          end
        end
      end
    end
    queue.join
  end

  def s3_path(impression)
    S3Client.path_for_impression(impression)
  end

  def logger
    Rails.logger
  end
end
