# Rootly Slack Bot and Incident Management

A Rails application that lets you declare, manage, and resolve incidents directly from Slack with an accompanying web UI for tracking and management.

## Features

### Slack Integration

- `/rootly declare <title>` - Opens a modal to create a new incident with optional description and severity
- `/rootly resolve` - Resolves an active incident (only works in incident-specific channels)

### Incident Management

- Creates dedicated Slack channels for each incident
- Tracks incident duration and resolution time
- Maintains historical record of all incidents

### Web UI

- Dashboard of all incidents with current status
- Sortable columns for easy filtering (title, severity, status, etc.)
- Real-time updates using Turbo

## Technology Stack

- **Backend**: Ruby on Rails 8
- **Database**: PostgreSQL
- **Frontend**:
  - Turbo Rails (for AJAX sorting without page reloads)
  - Tailwind CSS (for responsive UI)
- **Integration**: Slack API (via slack-ruby-client)

## Setup

### Prerequisites

- Ruby 3.2+ and Rails 8
- PostgreSQL
- Slack workspace with admin permissions

### Local Development

1. **Clone the repository**

   ```bash
   git clone https://github.com/Hungle2911/slack-bot.git
   cd slack-bot
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Setup database**

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Configure environment variables**
   Create a `.env` file in the root directory with:

   ```
   SLACK_API_TOKEN=
   ```

5. **Start the server**
   ```bash
   rails server
   ```

### Slack App Configuration

1. **Create a new Slack App** at https://api.slack.com/apps

2. **Add Bot Token Scopes**

   - `channels:manage` - To create incident channels
   - `chat:write` - To send messages
   - `channels:write.invites` - To add users to incident channels
   - `commands` - To use slash commands
   - `users:read` - To get user information

3. **Create a Slash Command**

   - Command: `/rootly`
   - Request URL: `https://your-app-url.com/api/slack/command`
   - Short Description: "Declare and resolve incidents"
   - Usage Hint: "declare <title> | resolve"

4. **Enable Interactivity**

   - Request URL: `https://your-app-url.com/api/slack/interactive`
   - This is needed for the modal to work

5. **Install the app to your workspace**

   - Once configured, install the app to your workspace
   - Copy the Bot User OAuth Token to your `.env` file

6. **For local development**
   - Use a service like ngrok to expose your local server
   - Update the Request URLs with your ngrok URL

## Usage

### Declaring an Incident

1. In any Slack channel, type: `/rootly declare Database connectivity issues`
2. Complete the modal form with additional details:
   - Description (optional)
   - Severity (optional: sev0, sev1, sev2)
3. Submit the form to create the incident
4. A new Slack channel will be created for the incident

### Resolving an Incident

1. In the incident-specific Slack channel, type: `/rootly resolve`
2. The incident will be marked as resolved, and the resolution time will be displayed

### Web Dashboard

Access the web dashboard at the root URL of your application to see:

- All incidents (active and resolved)
- Sort by any column (title, severity, creator, time)
- Track resolution times

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Acknowledgements

- Inspired by the Rootly incident management platform
- Built with the awesome [Slack Ruby Client](https://github.com/slack-ruby/slack-ruby-client) gem
