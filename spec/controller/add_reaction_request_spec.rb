require "rails_helper"

RSpec.describe ReactionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let(:react_params) {
    {
      user_id: user.id,
      micropost: micropost.id,
      image_id: "1",
    }
  }
  before(:each) do
    log_in user
  end
  after(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end 
  it "should add reaction with valid information" do
    expect { post :create, params: react_params }.to change(Reaction, :count).by(1)
  end

  it "should destroy reaction with duplicate reaction" do
    react = FactoryBot.create(:reaction, user_id: user.id, micropost_id: micropost.id, image_id: "1")
    expect { post :create, params: react_params }.to change(Reaction, :count).by(-1)
    expect(Reaction.where(id: react.id).count).to eq(0)
  end

  it "should only has only 1 reaction per micropost per user" do
    react = FactoryBot.create(:reaction, user_id: user.id, micropost_id: micropost.id, image_id: "2")

    post :create, params: react_params
    expect(Reaction.where(user_id: user.id, micropost_id: micropost.id, image_id: "1").count).to eq(1)
    expect(Reaction.where(id: react.id).count).to eq(0)
  end
end
