Rails.application.routes.draw do
  namespace :api do
    post "slack/command", to: "slack#slash_command"
  end
end
