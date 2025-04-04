class SlackService
  attr_reader :client
  def initialize(team_id)
    team = Team.find_by(team_id: team_id)
    @client = Slack::Web::Client.new(token: team&.access_token || ENV["SLACK_BOT_TOKEN"])
  end

  def open_incident_modal(trigger_id, title = nil)
    client.views_open(
      trigger_id: trigger_id,
      view: {
        type: "modal",
        callback_id: "incident_modal",
        title: {
          type: "plain_text",
          text: "Declare Incident"
        },
        submit: {
          type: "plain_text",
          text: "Declare"
        },
        close: {
          type: "plain_text",
          text: "Cancel"
        },
        blocks: [
          {
            type: "input",
            block_id: "incident_title",
            element: {
              type: "plain_text_input",
              action_id: "title",
              initial_value: title,
              placeholder: {
                type: "plain_text",
                text: "Enter incident title"
              }
            },
            label: {
              type: "plain_text",
              text: "Title"
            }
          },
          {
            type: "input",
            block_id: "incident_description",
            optional: true,
            element: {
              type: "plain_text_input",
              action_id: "description",
              multiline: true,
              placeholder: {
                type: "plain_text",
                text: "Describe the incident"
              }
            },
            label: {
              type: "plain_text",
              text: "Description"
            }
          },
          {
            type: "input",
            block_id: "incident_severity",
            optional: true,
            element: {
              type: "static_select",
              action_id: "severity",
              placeholder: {
                type: "plain_text",
                text: "Select severity"
              },
              options: [
                {
                  text: {
                    type: "plain_text",
                    text: "SEV0 - Critical"
                  },
                  value: "sev0"
                },
                {
                  text: {
                    type: "plain_text",
                    text: "SEV1 - High"
                  },
                  value: "sev1"
                },
                {
                  text: {
                    type: "plain_text",
                    text: "SEV2 - Medium"
                  },
                  value: "sev2"
                }
              ]
            },
            label: {
              type: "plain_text",
              text: "Severity"
            }
          }
        ]
      }
    )
  end

  def create_new_channel(incident)
    sanitized_title = incident.title.downcase.gsub(/[^a-z0-9]/, "-")[0..20]
    channel_name = "inc-#{sanitized_title}-#{Time.now.strftime("%d-%m-%Y")}"

    response = client.conversations_create(name: channel_name)
    channel_id = response["channel"]["id"]
    incident_url = "https://#{ENV["APP_HOST_URL"]}/incidents/#{incident.id}"
    incident.update(slack_channel_id: channel_id)
    client.conversations_invite(channel: channel_id, users:  incident.creator_id)
    client.chat_postMessage(
      channel: channel_id,
      text: ":rotating_light: *INCIDENT DECLARED* :rotating_light:",
      blocks: [
        {
          type: "header",
          text: {
            type: "plain_text",
            text: "🚨 INCIDENT DECLARED 🚨"
          }
        },
        {
          type: "section",
          fields: [
            {
              type: "mrkdwn",
              text: "*Title:*\n#{incident.title}"
            },
            {
              type: "mrkdwn",
              text: "*Severity:*\n#{incident.severity || 'Not specified'}"
            },
            {
              type: "mrkdwn",
              text: "*Created by:*\n#{incident.creator_name}"
            },
            {
              type: "mrkdwn",
              text: "*View Incident Details:*\n#{incident_url}"
            }
          ]
        },
        {
      "type": "actions",
      "elements": [
        {
          "type": "button",
          "text": {
            "type": "plain_text",
            "emoji": true,
            "text": "✅ Resolve"
          },
          "value": "resolve_this_incident"
        },
        {
          "type": "button",
          "text": {
            "type": "plain_text",
            "emoji": true,
            "text": "Reject"
          },
          "value": "click_me_123"
        }
      ]
    }
      ]
    )

    channel_id
  end

  def resolve_incident(incident, channel_id)
    incident.resolve!

    client.chat_postMessage(
      channel: channel_id,
      text: ":white_check_mark: *INCIDENT RESOLVED* :white_check_mark:",
      blocks: [
        {
          type: "header",
          text: {
            type: "plain_text",
            text: "✅ INCIDENT RESOLVED ✅"
          }
        },
        {
          type: "section",
          fields: [
            {
              type: "mrkdwn",
              text: "*Time to resolution:*\n#{incident.resolution_time}"
            }
          ]
        }
      ]
    )
  end
end
