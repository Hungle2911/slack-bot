Rails.application.routes.draw do
  namespace :api do
    post "slack/command", to: "slack#slack_command"
  end
end
