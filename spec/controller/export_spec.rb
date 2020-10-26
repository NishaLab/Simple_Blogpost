require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }

  before(:each) do
    log_in user
  end
  it "should export correct data" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    user1.follow(user)
    user2.follow(user)
    user.follow(user1)
    get :export, params: { id: user.id }
    expect(response.header["Content-Type"]).to eq("application/zip")
    expect(response.status).to eq(200)
  end
  it "should not export other user data" do
    user1 = FactoryBot.create(:user)
    get :export, params: { id: user1.id }
    expect(response.status).to eq(302)
  end
  it "should not see all users data" do
    get :index
    expect(response.status).to eq(302)
  end
end
