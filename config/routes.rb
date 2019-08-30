Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'settings' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#home'

  get '/home', to: 'application#home', as: 'home'
  get '/secret', to: 'application#secret', as: 'secret'
  get '/about', to: 'application#about', as: 'about'
  get '/contact', to: 'application#contact', as: 'contact'
  get '/send_invite/:invitee_user', to: 'application#send_invite', as: 'send_invite'
  get '/accept_invite', to: 'application#accept_invite', as: 'accept_invite'
  get '/get_scores', to: 'application#get_scores', as: 'get_scores'
  post '/respond_scores.json', to: 'application#respond_scores', as: 'respond_scores'
  
  
end
