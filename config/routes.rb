Rails.application.routes.draw do
  root 'pages#home'

  get 'test_stl_viewer', to: 'pages#test_stl_viewer'
  get 'test_slider', to: 'pages#test_slider'

  devise_for :users, path: '', controllers: { registrations: :registrations,
                                              passwords: :passwords,
                                              sessions: :sessions,
                                              confirmations: :confirmations,
                                              unlocks: :unlocks }

  get 'exists/:username', to: 'users#exists',
                          username: /(?:[a-zA-Z0-9_\.][a-zA-Z0-9_\-\.]*[a-zA-Z0-9_\-]|[a-zA-Z0-9_])/

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
