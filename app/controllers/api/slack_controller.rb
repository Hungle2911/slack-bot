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
end
