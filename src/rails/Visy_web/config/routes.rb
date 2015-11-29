Rails.application.routes.draw do
  root  'videos#index'
  resources :videos
  resources :sounds
  resources :minisounds
  post 'get_minisound' => 'videos#get_minisound'
  post 'get_sound' => 'videos#get_sound'
  get 'sounds/:id/download' => 'sounds#download'
  get 'minisounds_reset' => 'minisounds#reset'
  get 'sounds_reset' => 'sounds#reset'
end
