require "rails_helper"

RSpec.describe DailyReportSlackService, type: :model do
  before(:each) do
    stub_request(:post, "https://hooks.slack.com/services/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")
      .with(
        body: {"payload" => "{\"username\":\"Report Bot\","\
          "\"icon_emoji\":\":bat:\",\"channel\":null,\"attachments\""\
          ":[{\"title\":\"Test Report\",\"fallback\":\"Test Report\",\"fields\":[{\"value\":\"TEst\"}"\
          ",{\"value\":\"\\u003c@U01EKC3S5U3\\u003e\"}]}]}"},
        headers: {
          "Accept" => "*/*",
       "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
       "Content-Type" => "application/x-www-form-urlencoded",
       "Host" => "hooks.slack.com",
       "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 400, body: "Stubby response", headers: {})
  end
  it "should create correct microposts data" do
    response = DailyReportSlackService.new.deliver
    expect(response).to be_an_instance_of(String)
  end
end
