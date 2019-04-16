Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, path: '', controllers: { registrations: :registrations,
                                              passwords: :passwords,
                                              sessions: :sessions,
                                              confirmations: :confirmations,
                                              unlocks: :unlocks }

  get 'exists/:username', to: 'users#exists',
                          username: /(?:[a-zA-Z0-9_\.][a-zA-Z0-9_\-\.]*[a-zA-Z0-9_\-]|[a-zA-Z0-9_])/

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
