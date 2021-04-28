# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'artist_invites/:id/daily', to: 'artist_invites#daily'
      get 'artist_invites/:id/total', to: 'artist_invites#total'
    end
  end
end
