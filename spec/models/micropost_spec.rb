require "rails_helper"

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:parent) { FactoryBot.create(:micropost, user_id: user.id) }
  let!(:post) { FactoryBot.create(:micropost, user_id: user.id) }

  it "is not valid without user id" do
    post = Micropost.new(user_id: nil, content: "123")
    expect(post).to_not be_valid
  end

  it "is not valid without content" do
    post = Micropost.new(content: nil, user_id: user.id)
    expect(post).to_not be_valid
  end

  it "is valid without parent id" do
    post = Micropost.new(content: "123", user_id: user.id, parent_id: nil)
    expect(post).to be_valid
  end
  it "should have new_posts correct scope data" do
    post2 = FactoryBot.create(:micropost,user_id: user.id, parent_id: nil, created_at: 2.days.ago)
    expect(Micropost.new_posts.count).to eq(1)
    expect(Micropost.new_posts).to include(post)
  end
end
