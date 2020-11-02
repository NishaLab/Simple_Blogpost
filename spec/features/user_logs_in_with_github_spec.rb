require "rails_helper"

RSpec.feature "user logs in github" do
  scenario "success using github oauth" do
    stub_omniauth_github
    visit login_path
    expect(page).to have_link("Sign in with Facebook")
    click_link "Sign in with Github"
    expect(page).to have_content("Hung Test")
    expect(page).to have_link("Log out")
  end
end

def stub_omniauth_github
  # first, set OmniAuth to run in test mode
  OmniAuth.config.test_mode = true
  # then, provide a set of fake oauth data that
  # omniauth will use when a user tries to authenticate:
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    provider: "facebook",
    uid: "123",
    info: {
      email: "hungtest@gmail.com",
      name: "Hung Test"
    },
    credentials: {
      token: "abcdefg12345",
      refresh_token: "12345abcdefg",
      expires_at: DateTime.now
    }
  )
end
