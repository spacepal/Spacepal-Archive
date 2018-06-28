Rails.application.routes.draw do

  
  namespace :api do
    get 'games' => 'game#index'
    post 'game/create'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
