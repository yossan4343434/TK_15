Rails.application.routes.draw do
  resources :videos
  resources :sounds
  resources :minisounds
  post 'get_minisound' => 'videos#get_minisound'
  post 'get_sound' => 'videos#get_sound'
  get 'sounds/:id/download' => 'sounds#download'
  get 'clean' => 'minisounds#clean'

end
