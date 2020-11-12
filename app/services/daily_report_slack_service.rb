class DailyReportSlackService
  NAME_AND_ICON = {
    username: "Report Bot",
    icon_emoji: ":bat:"
  }

  def initialize channel = ENV["SLACK_WEBHOOK_CHANNEL"]
    @uri = URI(ENV["SLACK_WEBHOOK_URL"])
    @channel = channel
  end

  def daily_report user_count, new_user_count, new_post_count, interactive_user
    params = {
      attachments: [
        {
          title: "Daily report",
          fallback: "Daily report",
          color: "Good",
          fields: [
            {
              title: "Current User Count",
              value: user_count,
              short: true
            },
            {
              title: "New User Count",
              value: new_user_count,
              short: true
            },
            {
              title: "New Post Count",
              value: new_post_count,
              short: true
            },
            {
              title: "Unique User Activity",
              value: interactive_user,
              short: true
            },
            {
              value: "<@U01EKC3S5U3> , <@U01EXTMQS3T>"
            }
          ]
        }
      ]
    }
    @params = generate_payload(params)
    self
  end

  def error_report message
    params = {
      attachments: [
        {
          title: "Error report",
          fallback: "Error report",
          fields: [
            {
              value: message
            },
            {
              value: "<@U01EKC3S5U3>"
            }
          ]
        }
      ]
    }
    @params = generate_payload(params)
    self
  end

  def deliver
    Net::HTTP.post_form(@uri, @params)
  rescue StandardError => e
    Rails.logger.error("BespokeSlackbotService: Error when sending: #{e.message}")
  end

  def generate_payload params
    {
      payload: NAME_AND_ICON
        .merge(channel: @channel)
        .merge(params).to_json
    }
  end
end
