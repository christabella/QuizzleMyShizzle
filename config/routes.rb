Rails.application.routes.draw do

  root 'pages#index'
  post 'upload', to: 'pages#upload'

  resources :decks, only: [:index, :show] do
    resources :cards, only: [:index, :show], controller: 'deck/cards' do
      member do
        post :speech_command
      end
    end
  end

end
