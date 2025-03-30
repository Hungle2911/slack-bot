Rails.application.routes.draw do
  namespace :api do
    post "slack/command", to: "slack#slash_command"
    post "slack/interactive", to: "slack#interactive"
  end
end
