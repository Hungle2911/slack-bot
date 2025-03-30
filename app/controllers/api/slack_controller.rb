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
    else
      render json: { text: "Unknown Interaction Type" }
    end
  end

  private
  def handle_rootly_command
    subcommand, *args = params[:text].to_s.split(" ")
    case subcommand
    when "declare"
      handle_declare_command(args.join(" "))
    else
      render json: {
        text: "Unknown subcommand: #{subcommand}. Available commands: `/rootly declare <title>` or `/rootly resolve`"
      }
    end
  end

  def handle_declare_command(title)
    slack_service = ::SlackService.new
    slack_service.open_incident_modal(params[:trigger_id], title)

    head :ok
  end

  def handle_modal_submission(payload)
    values = payload["view"]["state"]["values"]
    title = values.dig("incident_title", "title", "value")
    description = values.dig("incident_description", "description", "value")
    severity = values.dig("incident_severity", "severity", "selected_option", "value")

    user_id = payload["user"]["id"]
    creator_name = payload["user"]["username"]

    incident = Incident.create!(
      title: title,
      description: description,
      severity: severity,
      creator_id: user_id,
      creator_name: creator_name,
      status: "active"
    )
    ::SlackService.new.create_new_channel(incident)
    render json: {}
  end
end
