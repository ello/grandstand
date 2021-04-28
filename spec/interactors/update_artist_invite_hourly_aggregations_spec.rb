# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateArtistInviteHourlyAggregations, type: :model, freeze_time: true do

  before do
    # Because HourlyImpressions are not in primary db they are not rolled
    # back; so we do it manually here instead.
    ArtistInviteHourlyImpression.destroy_all
  end

  it 'creates new hourly aggregations by stream kind and ignores stream id' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 15),
      stream_kind: 'following',
      stream_id: 1,
      author_id: 0,
      post_id: 0,
      viewer_id: 1,
      artist_invite_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'following',
      stream_id: 2,
      author_id: 0,
      post_id: 1,
      viewer_id: 2,
      artist_invite_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 16),
      stream_kind: 'love',
      stream_id: 1,
      author_id: 0,
      post_id: 2,
      viewer_id: nil,
      artist_invite_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 46),
      stream_kind: 'love',
      stream_id: 2,
      author_id: 0,
      post_id: 3,
      viewer_id: 1,
      artist_invite_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'user',
      stream_id: 2,
      author_id: 0,
      post_id: 4,
      viewer_id: nil,
      artist_invite_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'category',
      stream_id: 2,
      author_id: 0,
      post_id: 5,
      viewer_id: nil,
      artist_invite_id: 1
    )

    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'category',
      stream_id: 2,
      author_id: 0,
      post_id: 6,
      viewer_id: nil,
      artist_invite_id: 2
    )
    described_class.call(date: Date.new(2017, 1, 1))
    expect(ArtistInviteHourlyImpression.count).to eq(5)
    following = ArtistInviteHourlyImpression.where(stream_kind: 'following').first
    expect(following.logged_in_views).to eq(2)
    expect(following.logged_out_views).to eq(0)
    love = ArtistInviteHourlyImpression.where(stream_kind: 'love').first
    expect(love.logged_in_views).to eq(1)
    expect(love.logged_out_views).to eq(1)
    user = ArtistInviteHourlyImpression.where(stream_kind: 'user').first
    expect(user.logged_in_views).to eq(0)
    expect(user.logged_out_views).to eq(1)
    category = ArtistInviteHourlyImpression.where(stream_kind: 'category').first
    expect(category.logged_in_views).to eq(0)
    expect(category.logged_out_views).to eq(1)
    expect(ArtistInviteHourlyImpression.where(artist_invite_id: 1).count).to eq(4)
    expect(ArtistInviteHourlyImpression.where(artist_invite_id: 2).count).to eq(1)
  end
end
