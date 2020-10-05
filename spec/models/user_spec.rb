require "rails_helper"

RSpec.describe User, type: :model do
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
end

RSpec.describe User, type: :model do
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
end
