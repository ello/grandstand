class Api::V1::ArtistInvitesController < ApplicationController
  def daily
    impressions = ArtistInviteHourlyImpression
                  .daily_aggregation(start_date, end_date, artist_invite_id)

    render json: { data: impressions }.to_json
  end

  def total
    total_impressions = ArtistInviteHourlyImpression
                        .total_aggregation(artist_invite_id)
                        .first

    render json: { data: total_impressions }.to_json
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
end
