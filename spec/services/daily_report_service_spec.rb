require "rails_helper"

RSpec.describe DailyReportSlackService, type: :model do
  it "should handle response failure" do
    @uri = URI(ENV["SLACK_WEBHOOK_URL"])
    params = {
      attachments: [
        {
          title: "Error report"
        }
      ]
    }
    @params = DailyReportSlackService.new.generate_payload(params)
    VCR.use_cassette "send message", record: :once do
      response = Net::HTTP.post_form(@uri, @params)
      raise "Error code #{response.code}" if response.code != "200"
    rescue StandardError => e
      expect(e.message).to eq("Error code #{response.code}")
    end
  end
end
