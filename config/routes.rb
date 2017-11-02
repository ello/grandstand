Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      match 'artist_invites/:id/daily', to: 'artist_invites#daily', via: :get
      match 'artist_invites/:id/total', to: 'artist_invites#total', via: :get
    end
  end
end
