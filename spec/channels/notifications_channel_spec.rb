require "rails_helper"

RSpec.describe NotificationsChannel, type: :channel do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }

  before do
    @action_cable = ActionCable.server
  end

  it "should be able to subscribe" do
    subscribe
    expect(subscription).to be_confirmed
  end
end
