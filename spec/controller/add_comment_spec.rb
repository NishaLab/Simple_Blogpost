require "rails_helper"

RSpec.describe MicropostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:parent) { FactoryBot.create(:micropost, user_id: user.id) }
  let(:post_params) {
    {
      micropost: { content: "hung12345"},
      user_id: user.id,
      parent_id: nil,
      format: "js"
    }
  }
  let!(:comment_params) {
    {
      micropost: { content: "hung12345" },
      user_id: user.id,
      parent_id: parent.id,
      format: "js"
    }
  }

  before(:each) do
    log_in user
  end

  it "shold create post with valid information" do
    expect { post :create, params: post_params }.to change(Micropost, :count).by(1)
  end

  it "should create comment with valid infomation" do
    expect { post :create, params: comment_params }.to change(Micropost, :count).by(1) &&
                                                      change(parent.child_posts, :count).by(1)
  end

  it "should re render the current page" do
    post :create, params: comment_params
    expect(response).to render_template(:create)
  end
end
