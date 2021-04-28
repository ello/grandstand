# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/artist_invites/:id/total', type: :request do
  let(:response_json) { JSON.parse(response.body) }
  let(:artist_invite_id) { 1 }
  let(:create_hourly_impressions) do
    (1..10).each do |n|
      ArtistInviteHourlyImpression.create(
        starting_at: DateTime.new(2017, 1, n, 0o0, 0o0, 0o0),
        artist_invite_id: artist_invite_id,
        stream_kind: 'following',
        logged_in_views: 5,
        logged_out_views: 5
      )
    end
  end

  context 'with an authenticated request' do
    before do
      reset_aggregation_db
    end

    it 'returns total post impression count' do
      create_hourly_impressions

      get "/api/v1/artist_invites/#{artist_invite_id}/total", headers: basic_auth_headers('user', 'password')

      expect(response.status).to eq(200)
      expect(response_json['data']).to eq([{
                                            'artist_invite_id' => '1',
                                            'impressions' => 100,
                                            'stream_kind' => nil
                                          }])
    end

    it 'returns proper response with 0 impressions' do
      get "/api/v1/artist_invites/#{artist_invite_id}/total", headers: basic_auth_headers('user', 'password')

      expect(response.status).to eq(200)
      expect(response_json['data']).to eq([{
                                            'artist_invite_id' => '1',
                                            'impressions' => 0,
                                            'stream_kind' => nil
                                          }])
    end
  end

  context 'with an unauthenticated request' do
    before do
      reset_aggregation_db
      create_hourly_impressions
    end

    it 'returns a 401' do
      get "/api/v1/artist_invites/#{artist_invite_id}/total", headers: basic_auth_headers('user', 'wrong_password')

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
