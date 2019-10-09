Rails.application.routes.draw do
  root 'pages#home'

  get 'test_stl_viewer', to: 'pages#test_stl_viewer'
  get 'upload', to: 'pages#upload'

  resources :uploads

  resources :illustrations

  resources :blueprints

  resources :designs, except: :show
  get '/3d-model/:category/:id', to: 'designs#show', as: :design_show, constraints: { id: /.*\D+.*/ }
  get '/design/download/:id', to: 'designs#download', as: :design_download,constraints: { id: /.*\D+.*/ }

  devise_for :users, path: '', controllers: { registrations: :registrations,
                                              passwords: :passwords,
                                              sessions: :sessions,
                                              confirmations: :confirmations,
                                              unlocks: :unlocks }

  get 'exists/:username', to: 'users#exists',
                          username: /(?:[a-zA-Z0-9_\.][a-zA-Z0-9_\-\.]*[a-zA-Z0-9_\-]|[a-zA-Z0-9_])/

  resource :profile, only: %i[show update] do
    scope module: :profiles do
      resource :account, only: %i[show update]
      resource :password, only: %i[edit update] do
        member do
          put :reset
        end
      end
    end
  end

  # this should be last route
  # TODO: redirect 404 page (customize 404 page)
  get '*path' => redirect('/')

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  mount Sail::Engine => '/sail'
end
