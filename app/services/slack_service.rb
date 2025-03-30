class SlackService
  attr_reader :client
  def initialize
    @client = Slack::Web::Client.new(token: ENV["SLACK_API_TOKEN"])
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
end
