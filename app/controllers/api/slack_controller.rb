class Api::SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def slash_command
    case params[:command]
    when "/rootly"
      handle_rootly_command
    else
      render json: { text: "Unknown Command. Please check your command" }
    end
  end

  def interactive
    payload = JSON.parse(params[:payload])
    case payload["type"]
    when "view_submission"
      handle_modal_submission(payload)
    when "block_actions"
      handle_block_actions(payload)
    else
      render json: { text: "Unknown Interaction Type" }
    end
  end

  private
  def handle_rootly_command
    team_id = params[:team_id]
    subcommand, *args = params[:text].to_s.split(" ")
    case subcommand
    when "declare"
      handle_declare_command(args.join(" "), team_id)
    when "resolve"
      handle_resolve_command(team_id)
    else
      render json: {
        text: "Unknown subcommand: #{subcommand}. Available commands: `/rootly declare <title>` or `/rootly resolve`"
      }
    end
  end

  def handle_declare_command(title, team_id)
    slack_service = ::SlackService.new(team_id)
    slack_service.open_incident_modal(params[:trigger_id], title)

    head :ok
  end

  def handle_resolve_command(team_id)
    channel_id = params[:channel_id]
    resolve_incident(team_id, channel_id)
  end

  def handle_block_actions(payload)
    action_value = payload["actions"][0]["value"]
    channel_id = payload["channel"]["id"]
    team_id = payload["team"]["id"]
    case action_value
    when "resolve_this_incident"
      resolve_incident(team_id, channel_id)
    end
  end

  def resolve_incident(team_id, channel_id)
    incident = Incident.find_by(slack_channel_id: channel_id)

    if incident.nil?
      render json: {
        text: "This can only be used in an incident channel."
      }
      return
    end

    if incident.active?
      slack_service = ::SlackService.new(team_id)
      slack_service.resolve_incident(incident, channel_id)

      render json: {
        text: "Incident has been resolved. Time to resolution: #{incident.resolution_time}"
      }
    else
      render json: {
        text: "This incident has already been resolved."
      }
    end
  end

  def handle_modal_submission(payload)
    values = payload["view"]["state"]["values"]
    title = values.dig("incident_title", "title", "value")
    description = values.dig("incident_description", "description", "value")
    severity = values.dig("incident_severity", "severity", "selected_option", "value")

    user_id = payload["user"]["id"]
    creator_name = payload["user"]["username"]
    team_id = payload["team"]["id"]

    incident = Incident.create!(
      title: title,
      description: description,
      severity: severity,
      creator_id: user_id,
      creator_name: creator_name,
      status: "active",
      team_id: team_id
    )
    ::SlackService.new(team_id).create_new_channel(incident)
    render json: {}
  end
end
