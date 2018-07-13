Rails.application.routes.draw do

  namespace :test do
    get 'cookies/get'
    get 'cookies/set'
    get 'cookies/del'
  end
  namespace :api do
    get 'games' => 'game#index'
    post 'games' => 'game#create'
    put 'games/(:id)/join' => 'game#join'
    delete 'games/(:id)/player' => 'game#leave'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
