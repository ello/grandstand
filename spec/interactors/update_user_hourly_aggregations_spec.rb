require 'rails_helper'

RSpec.describe UpdateUserHourlyAggregations, type: :model, freeze_time: true do

  before do
    # Because UserHourlyImpressions are not in primary db they are not rolled
    # back; so we do it manually here instead.
    UserHourlyImpression.destroy_all
  end

  it 'creates new hourly aggregations for given author' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 15),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 1,
      post_id: 0,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 1,
      post_id: 1,
      viewer_id: 2,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 16),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 0,
      post_id: 2,
      viewer_id: nil,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 46),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 0,
      post_id: 3,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 13, 45),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 1,
      post_id: 4,
      viewer_id: nil,
    )
    described_class.call(date: Date.new(2017, 1, 1), author_id: 0)
    described_class.call(date: Date.new(2017, 1, 1), author_id: 1)
    expect(UserHourlyImpression.where(author_id: 0).count).to eq(24)
    expect(UserHourlyImpression.where(author_id: 0).pluck(:views)).to eq([
      0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0
    ])
    expect(UserHourlyImpression.where(author_id: 1).count).to eq(24)
    expect(UserHourlyImpression.where(author_id: 1).pluck(:views)).to eq([
      0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,0,0,0,0,0,0
    ])
  end
end
