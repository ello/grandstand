require 'rails_helper'

RSpec.describe CreateEventFromStream, type: :model, freeze_time: true do

  describe 'with a valid and fully-populated record' do
    let(:record) do
      { 'author'    => { 'id' => '1' },
        'post'      => { 'id' => '10' },
        'viewer'    => { 'id' => '2' },
        'viewed_at' => Time.now.to_f }
    end

    it 'stores an impression model' do
      described_class.call(kind: 'post_was_viewed', record:  record)
      expect(Impression.count).to eq(1)
      last_impression = Impression.last
      expect(last_impression.author_id).to eq('1')
      expect(last_impression.post_id).to eq('10')
      expect(last_impression.viewer_id).to eq('2')
      expect(last_impression.created_at).to eq(Time.now)
    end

    it 'silently drops duplicated records' do
      2.times do
        described_class.call(kind: 'post_was_viewed', record:  record)
      end
      expect(Impression.count).to eq(1)
    end
  end

  describe 'with a record that has no viewer' do
    let(:record) do
      { 'author'    => { 'id' => '1' },
        'post'      => { 'id' => '10' },
        'viewed_at' => Time.now.to_f }
    end

    it 'stores an impression model' do
      described_class.call(kind: 'post_was_viewed', record:  record)
      expect(Impression.count).to eq(1)
      last_impression = Impression.last
      expect(last_impression.author_id).to eq('1')
      expect(last_impression.post_id).to eq('10')
      expect(last_impression.viewer_id).to be_nil
      expect(last_impression.created_at).to eq(Time.now)
    end
  end

  describe 'with an inapplicable record kind' do
    it 'ignores the record' do
      described_class.call(kind: 'post_was_loved', record:  {})
      expect(Impression.count).to eq(0)
    end
  end
end