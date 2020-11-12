require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  it "creates or updates itself from an google-auth hash" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google",
      uid: "12345678910",
      info: {
        email: "hungtestmail@gmail.com",
        name: "Hung123"
      },
      credentials: {
        token: "abcdefg12345",
        refresh_token: "12345abcdefg",
        expires_at: DateTime.now
      }
    )
    new_user = User.from_omniauth(OmniAuth.config.mock_auth[:google_oauth2])
    expect(new_user.email).to eq("hungtestmail@gmail.com")
    expect(new_user.name).to eq("Hung123")
  end
  it "creates or updates itself from an facebook hash" do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: "facebook",
      uid: "12345678910",
      info: {
        email: "hungtestmail@gmail.com",
        name: "Hung123"
      },
      credentials: {
        token: "abcdefg12345",
        refresh_token: "12345abcdefg",
        expires_at: DateTime.now
      }
    )
    new_user = User.from_omniauth(OmniAuth.config.mock_auth[:facebook])
    expect(new_user.email).to eq("hungtestmail@gmail.com")
    expect(new_user.name).to eq("Hung123")
  end

  it "should have new_users correct scope data" do
    user1 = FactoryBot.create(:user,created_at: 2.days.ago)
    expect(User.new_users.count).to eq(1)
    expect(User.new_users).to include(user)
  end
end
