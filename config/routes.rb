Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      match 'artist_invites/:id/daily', to: 'artist_invites#daily', via: :get
    end
  end
end
