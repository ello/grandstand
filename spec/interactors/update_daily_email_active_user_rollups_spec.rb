require 'rails_helper'

RSpec.describe UpdateDailyEmailActiveUserRollups, type: :model, freeze_time: true do

  before do
    # Because EmailActiveUserRollup are not in primary db they are not rolled
    # back; so we do it manually here instead.
    EmailActiveUserRollup.destroy_all
  end

  it 'creates new hourly aggregations by stream kind for non category streams' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 15),
      stream_kind: 'email',
      stream_id: 1,
      author_id: 0,
      post_id: 0,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'email',
      author_id: 0,
      post_id: 1,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'email',
      author_id: 0,
      post_id: 2,
      viewer_id: nil,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 2, 12, 15),
      stream_kind: 'email',
      author_id: 0,
      post_id: 3,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 2, 12, 45),
      stream_kind: 'email',
      author_id: 0,
      post_id: 1,
      viewer_id: 2,
    )
    described_class.call(date: Date.new(2017, 1, 2))
    expect(EmailActiveUserRollup.count).to eq(1)
    email_mau = EmailActiveUserRollup.first
    expect(email_mau.day_total).to eq(2)
    expect(email_mau.thirty_day_total).to eq(2)
  end

  it 'updates existing records' do
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 15),
      stream_kind: 'email',
      stream_id: 1,
      author_id: 0,
      post_id: 0,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'email',
      author_id: 0,
      post_id: 1,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 1, 12, 45),
      stream_kind: 'email',
      author_id: 0,
      post_id: 2,
      viewer_id: nil,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 2, 12, 15),
      stream_kind: 'email',
      author_id: 0,
      post_id: 3,
      viewer_id: 1,
    )
    Impression.create(
      created_at: DateTime.new(2017, 1, 2, 12, 45),
      stream_kind: 'email',
      author_id: 0,
      post_id: 1,
      viewer_id: 2,
    )
    EmailActiveUserRollup.create(
      day: Date.new(2017, 1, 2),
      day_total: 0,
      thirty_day_total: 0
    )
    described_class.call(date: Date.new(2017, 1, 2))
    expect(EmailActiveUserRollup.count).to eq(1)
    email_mau = EmailActiveUserRollup.first
    expect(email_mau.day_total).to eq(2)
    expect(email_mau.thirty_day_total).to eq(2)
  end
end
