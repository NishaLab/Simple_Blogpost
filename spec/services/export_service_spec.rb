require "rails_helper"

RSpec.describe ExportCsvService, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:user3) { FactoryBot.create(:user) }
  let!(:user4) { FactoryBot.create(:user) }

  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }

  before(:each) do
    @csv = ExportCsvService.new
  end
  it "should create correct microposts data" do
    post = user.microposts.create(content: "Adasdas", created_at: 2.months.ago)
    comment = Micropost.create(parent_id: micropost.id, user_id: user.id, content: "Comment")
    @csv.export_posts(user.id)
    expect(@csv.attributes).to eq(Micropost::MICROPOST_ATTRIBUTES)
    expect(@csv.objects).not_to include(post)
    expect(@csv.objects).not_to include(comment)
    expect(@csv.objects).to include(micropost)
  end

  it "should create correct followers data" do
    rel1 = Relationship.create(follower_id: user2.id, followed_id: user.id)
    rel2 = Relationship.create(follower_id: user3.id, followed_id: user.id, created_at: 2.months.ago)
    rel3 = Relationship.create(follower_id: user.id, followed_id: user4.id, created_at: 2.months.ago)

    @csv.export_followers(user.id)
    expect(@csv.attributes).to eq(Relationship::FOLLOWER_ATTRIBUTES)

    expect(@csv.objects).not_to include(rel3)
    expect(@csv.objects).not_to include(rel2)
    expect(@csv.objects).to include(rel1)
  end

  it "should create correct followings data" do
    rel1 = Relationship.create(follower_id: user.id, followed_id: user2.id)
    rel2 = Relationship.create(follower_id: user.id, followed_id: user3.id, created_at: 2.months.ago)
    rel3 = Relationship.create(follower_id: user4.id, followed_id: user.id, created_at: 2.months.ago)

    @csv.export_followings(user.id)
    expect(@csv.attributes).to eq(Relationship::FOLLOWING_ATTRIBUTES)

    expect(@csv.objects).not_to include(rel3)
    expect(@csv.objects).not_to include(rel2)
    expect(@csv.objects).to include(rel1)
  end
end
