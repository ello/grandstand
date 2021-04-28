# frozen_string_literal: true

class Api::V1::ArtistInvitesController < ApplicationController
  def daily
    impressions = ArtistInviteHourlyImpression
                  .daily_aggregation(start_date, end_date, artist_invite_id)

    if impressions.empty?
      head :no_content
    else
      render json: { data: impressions }.to_json
    end
  end

  def total
    total_impressions = ArtistInviteHourlyImpression
                        .total_aggregation(artist_invite_id)
                        .first

    render json: total_json_response(total_impressions)
  end

  private

  def artist_invite_id
    params[:id]
  end

  def start_date
    params[:starting]
  end

  def end_date
    params[:ending]
  end

  def total_json_response(impressions)
    if impressions
      { data: [impressions] }.to_json
    else
      { data: [{ artist_invite_id: artist_invite_id, impressions: 0, stream_kind: nil }] }.to_json
    end
  end
end
