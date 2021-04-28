# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe UpdateHourlyAggregations, type: :model, freeze_time: true do

  before do
    # Because HourlyImpressions are not in primary db they are not rolled
    # back; so we do it manually here instead.
    HourlyImpression.destroy_all
  end

  it 'creates new hourly aggregations by stream kind for non category streams' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 15),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 0,
      post_id: 0,
      viewer_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'following',
      stream_id: 2,
      author_id: 0,
      post_id: 1,
      viewer_id: 2
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 16),
      stream_kind: 'love',
      stream_id: 1,
      author_id: 0,
      post_id: 2,
      viewer_id: nil
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 46),
      stream_kind: 'love',
      stream_id: 2,
      author_id: 0,
      post_id: 3,
      viewer_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'user',
      stream_id: 2,
      author_id: 0,
      post_id: 4,
      viewer_id: nil
    )
    described_class.call(date: Date.new(2017, 1, 1))
    expect(HourlyImpression.count).to eq(3)
    following = HourlyImpression.where(stream_kind: 'following').first
    expect(following.logged_in_views).to eq(2)
    expect(following.logged_out_views).to eq(0)
    expect(following.stream_id).to be_nil
    love = HourlyImpression.where(stream_kind: 'love').first
    expect(love.logged_in_views).to eq(1)
    expect(love.logged_out_views).to eq(1)
    expect(love.stream_id).to be_nil
    user = HourlyImpression.where(stream_kind: 'user').first
    expect(user.logged_in_views).to eq(0)
    expect(user.logged_out_views).to eq(1)
    expect(user.stream_id).to be_nil
  end

  it 'tracks category streams by stream id' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 16),
      stream_kind: 'category',
      stream_id: 1,
      author_id: 0,
      post_id: 2,
      viewer_id: nil
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 46),
      stream_kind: 'category',
      stream_id: 1,
      author_id: 0,
      post_id: 3,
      viewer_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'category',
      stream_id: 2,
      author_id: 0,
      post_id: 4,
      viewer_id: nil
    )
    described_class.call(date: Date.new(2017, 1, 1))
    expect(HourlyImpression.count).to eq(2)
    cat1 = HourlyImpression.where(stream_kind: 'category', stream_id: 1).first
    expect(cat1.logged_in_views).to eq(1)
    expect(cat1.logged_out_views).to eq(1)
    cat2 = HourlyImpression.where(stream_kind: 'category', stream_id: 2).first
    expect(cat2.logged_in_views).to eq(0)
    expect(cat2.logged_out_views).to eq(1)
  end

  it 'creates an hourly impression record for each hour' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 0o0, 0o0),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 0,
      post_id: 0,
      viewer_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 59, 59),
      stream_kind: 'following',
      stream_id: 2,
      author_id: 0,
      post_id: 1,
      viewer_id: 2
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 13, 0o0, 0o0),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 0,
      post_id: 0,
      viewer_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 13, 59, 59),
      stream_kind: 'following',
      stream_id: 2,
      author_id: 0,
      post_id: 1,
      viewer_id: 2
    )
    described_class.call(date: Date.new(2017, 1, 1))
    expect(HourlyImpression.count).to eq(2)
  end

  it 'includes impressions not tagged with a stream kind' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 13, 0o0, 0o0),
      author_id: 0,
      post_id: 0,
      viewer_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 13, 59, 59),
      author_id: 0,
      post_id: 1,
      viewer_id: 2
    )
    described_class.call(date: Date.new(2017, 1, 1))
    expect(HourlyImpression.count).to eq(1)

    HourlyImpression.last
  end

end
# rubocop:enable Metrics/BlockLength
