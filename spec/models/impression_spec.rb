# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Impression, type: :model do
  describe 'preventing duplicates' do
    it 'does not allow duplicate impressions to be created' do
      attrs = { post_id: '1', author_id: '1', created_at: Time.zone.now }
      expect { 2.times { described_class.create!(attrs) } }.to raise_exception(ActiveRecord::RecordNotUnique)
    end

    it 'does not allow invalid impressions to be created' do
      expect { 2.times { described_class.create!({}) } }.to raise_exception(ActiveRecord::StatementInvalid)
    end
  end
end
