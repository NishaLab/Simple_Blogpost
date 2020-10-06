require "rails_helper"

RSpec.feature "user react" do
  scenario "micropost feed after login" do
    user = FactoryBot.create(:user, email: "abcs12@gmail.com")
    micropost = FactoryBot.create(:micropost, user_id: user.id)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    visit root_url

    expect(page).to have_css(".microposts")
    expect(page).to have_content(micropost.content)

    expect(page).to have_css("input[name=img-submit-1]")
    expect(page).to have_css("input[name=img-submit-2]")
    expect(page).to have_css("input[name=img-submit-3]")
    expect(page).to have_css("input[name=img-submit-4]")

    expect(page).to have_css("#react-count-1")
    expect(page).to have_css("#react-count-2")
    expect(page).to have_css("#react-count-3")
    expect(page).to have_css("#react-count-4")

    find('input[name="img-submit-1"]').click

    expect(page).to have_css(".microposts")
    expect(page).to have_content(micropost.content)

    expect(page).to have_css("input[name=img-submit-1]")
    expect(page).to have_css("input[name=img-submit-2]")
    expect(page).to have_css("input[name=img-submit-3]")
    expect(page).to have_css("input[name=img-submit-4]")

    expect(page).to have_css("#react-count-1")
    expect(page).to have_css("#react-count-2")
    expect(page).to have_css("#react-count-3")
    expect(page).to have_css("#react-count-4")
  end
end
