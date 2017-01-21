Rails.application.routes.draw do

  root 'pages#index'
  post 'upload', to: 'pages#upload'

  resources :decks, only: [:index] do
    resources :cards, only: [:index, :show]
  end

end
