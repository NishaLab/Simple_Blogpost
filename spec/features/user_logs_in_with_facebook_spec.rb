require "rails_helper"

RSpec.feature "user logs in facebook" do
  scenario "success using facebook oauth" do
    stub_omniauth_facebook
    visit login_path
    expect(page).to have_link("Sign in with Facebook")
    click_link "Sign in with Facebook"
    expect(page).to have_content("Hung Test")
    expect(page).to have_link("Log out")
  end
end

def stub_omniauth_facebook
  # first, set OmniAuth to run in test mode
  OmniAuth.config.test_mode = true
  # then, provide a set of fake oauth data that
  # omniauth will use when a user tries to authenticate:
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
    provider: "facebook",
    uid: "123",
    info: {
      email: "hungtest@gmail.com",
      name: "Hung Test123"
    },
    credentials: {
      token: "abcdefg12345",
      refresh_token: "12345abcdefg",
      expires_at: DateTime.now
    }
  )
end
