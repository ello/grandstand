require 'rails_helper'

RSpec.describe 'GET /api/v1/artist_invites/:id/daily', type: :request do
  let(:response_json) { JSON.parse(response.body) }
  let(:artist_invite_id) { 1 }
  let(:starting) { DateTime.new(2017, 1, 1, 00, 00, 00) }
  let(:ending) { DateTime.new(2017, 1, 10, 00, 00, 00) }
  let(:create_hourly_impressions) do
    (1..10).each do |n|
      ArtistInviteHourlyImpression.create(
        starting_at: DateTime.new(2017, 1, n, 00, 00, 00),
        artist_invite_id: artist_invite_id,
        stream_kind: 'following',
        logged_in_views: 5,
        logged_out_views: 5,
      )
    end
  end

  context 'Authenticated Request' do
    before do
      reset_aggregation_db
      create_hourly_impressions
    end

    it 'should return daily post impression count' do
      get "/api/v1/artist_invites/#{artist_invite_id}/daily", params: { starting: starting, ending: ending },
                                                              headers: basic_auth_headers('user', 'password')

      expect(response.status).to eq(200)
      expect(response_json['data'].length).to eq(10)
      expect(response_json['data'][0]).to eq({
        "artist_invite_id"=>"1",
        "date"=>"2017-01-01",
        "impressions"=>10,
        "stream_kind" => nil,
      })
    end
  end

  context 'Unauthenticated Request' do
    before do
      reset_aggregation_db
      create_hourly_impressions
    end

    it 'should return a 401' do
      get "/api/v1/artist_invites/#{artist_invite_id}/daily", params: { starting: starting, ending: ending },
                                                              headers: basic_auth_headers('user', 'wrong_password')

      expect(response.status).to eq(401)
    end
  end

  private

  def basic_auth_headers(user, password)
    {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic
                              .encode_credentials(user, password)
    }
  end

  def reset_aggregation_db
    # Because HourlyImpressions are not in primary db they are not rolled
    # back; so we do it manually here instead.
    ArtistInviteHourlyImpression.destroy_all
  end
end
