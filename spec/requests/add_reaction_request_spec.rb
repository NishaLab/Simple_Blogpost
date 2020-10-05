require "rails_helper"

RSpec.describe ReactionsController, type: :controller do
  it "should add reaction with valid information" do
    user = FactoryBot.create(:user)
    log_in user
    micropost = FactoryBot.create(:micropost, user_id: user.id)
    react_params = {
      user_id: user.id,
      micropost: micropost.id,
      image_id: "1"
    }
    expect {post :create, params: react_params}.to change(Reaction, :count).by(1)
  end
  it "should destroy reaction with duplicate reaction" do
    user = FactoryBot.create(:user)
    log_in user
    micropost = FactoryBot.create(:micropost, user_id: user.id)
    react = FactoryBot.create(:reaction, user_id: user.id, micropost_id: micropost.id, image_id: "1")
    react_params = {
      user_id: user.id,
      micropost: micropost.id,
      image_id: "1"
    }
    expect {post :create, params: react_params}.to change(Reaction, :count).by(-1)
    expect(Reaction.where(id: react.id).count).to eq(0)
  end
  it "should only has only 1 reaction per micropost per user" do
    user = FactoryBot.create(:user)
    log_in user
    micropost = FactoryBot.create(:micropost, user_id: user.id)
    react = FactoryBot.create(:reaction, user_id: user.id, micropost_id: micropost.id, image_id: "2")

    react_params = {
      user_id: user.id,
      micropost: micropost.id,
      image_id: "1"
    }
    post :create, params: react_params
    expect(Reaction.where(user_id: user.id, micropost_id: micropost.id, image_id: "1").count).to eq(1)
    expect(Reaction.where(id: react.id).count).to eq(0)
  end
end
