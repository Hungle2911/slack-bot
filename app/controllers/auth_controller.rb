class AuthController < ApplicationController
  def slack_callback
    if params[:error].present?
      redirect_to root_path, alert: "Authorization failed: #{params[:error]}"
      return
    end

    client = Slack::Web::Client.new

    begin
      response = client.oauth_v2_access(
        client_id: ENV["SLACK_CLIENT_ID"],
        client_secret: ENV["SLACK_CLIENT_SECRET"],
        code: params[:code],
        redirect_uri: auth_slack_callback_url
      )



      team = Team.find_or_create_by(team_id: response.team.id)
      team.update(
        access_token: response.access_token,
        bot_user_id: response.bot_user_id,
        team_name: response.team.name
      )

      redirect_to root_path, notice: "Successfully connected to #{response.team.name}!"
    rescue Slack::Web::Api::Errors => e
      redirect_to root_path, alert: "Error: #{e.message}"
    end
  end
end
