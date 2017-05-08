require 'rails_helper'

RSpec.describe SendEventToS3, type: :model, freeze_time: true do

  describe 'with a valid and fully-populated record' do
    let(:opts) { { schema_name: 'PostWasViewed', shard_id: '001' } }
    let(:record) do
      { 'author'      => { 'id' => '1' },
        'post'        => { 'id' => '10' },
        'viewer'      => { 'id' => '2' },
        'stream_kind' => 'category',
        'stream_id'   => '10',
        'uuid'        => '12345',
        'viewed_at'   => Time.now.to_f }
    end

    before { allow(S3Client).to receive(:upload) }

    it 'uploads an impression event on S3' do
      described_class.call(record: record, opts: opts)
      expect(S3Client).to have_received(:upload)
    end
  end

end
