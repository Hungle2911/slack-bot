class Api::SlackController < ApplicationController
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

  def handle_declare_command
  end
end
