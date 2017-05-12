require 'aws-sdk'

module S3Client
  class << self

    def upload(filename:, body:)
      obj = s3_bucket.object(filename)
      unless obj.exists?
        obj.put(body: body)
      end
    end

    def path_for_impression(impression)
      created_at = impression.created_at.strftime("%Y-%m-%d")
      "created_at=#{created_at}"
    end

    private

    def s3_bucket
      @s3_bucket ||= Aws::S3::Resource.new.bucket(ENV['S3_IMPRESSIONS_BUCKET'] || 'ello-impressions-test')
    end
  end
end
