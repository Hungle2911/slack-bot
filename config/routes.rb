Rails.application.routes.draw do
  root "incidents#index"

  resources :incidents, only: [ :index, :show ]
  get "auth/slack/callback", to: "auth#slack_callback"
  namespace :api do
    post "slack/command", to: "slack#slash_command"
    post "slack/interactive", to: "slack#interactive"
  end
end
