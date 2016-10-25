require 'rails_helper'

RSpec.describe Impression, type: :model do
  it { is_expected.to validate_presence_of(:post_id) }
  it { is_expected.to validate_presence_of(:author_id) }
  it { is_expected.to validate_presence_of(:created_at) }

  describe 'preventing duplicates' do
    it 'does not allow duplicate impressions to be created' do
      attrs = { post_id: "1", author_id: "1", created_at: Time.zone.now }
      expect { 2.times { Impression.create!(attrs) } }.to raise_exception(ActiveRecord::RecordNotUnique)
    end
  end
end
