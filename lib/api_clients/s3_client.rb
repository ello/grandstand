require 'aws-sdk'

module S3Client
  class << self
    def upload(filename:, body:)
      obj = s3_bucket.object(filename)
      obj.put(body: body)
    end

    private

    def s3_bucket
      @s3_bucket ||= Aws::S3::Resource.new.bucket(ENV['S3_IMPRESSIONS_BUCKET'] || 'ello-impressions-test')
    end
  end
end
