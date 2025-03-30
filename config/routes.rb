Rails.application.routes.draw do
  root "incidents#index"

  resources :incidents, only: [ :index ]
  namespace :api do
    post "slack/command", to: "slack#slash_command"
    post "slack/interactive", to: "slack#interactive"
  end
end
