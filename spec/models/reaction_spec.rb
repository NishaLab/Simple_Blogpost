require "rails_helper"

RSpec.describe Reaction, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }

  it "is not valid without user id" do
    react = Reaction.new(user_id: nil)
    expect(react).to_not be_valid
  end
  it "is not valid without micropost id" do
    react = Reaction.new(micropost_id: nil)
    expect(react).to_not be_valid
  end
  it "is not valid without image id" do
    react = Reaction.new(image_id: nil)
    expect(react).to_not be_valid
  end
  it "should have correct new reaction scope data" do
    react1 = FactoryBot.create(:reaction, user_id: user.id, micropost_id: micropost.id, image_id: 1)
    react2 = FactoryBot.create(:reaction, user_id: user2.id,
       micropost_id: micropost.id,
       image_id: 1, created_at: 2.days.ago)
    expect(Reaction.new_reactions.count).to eq(1)
    expect(Reaction.new_reactions).to include(react1)
    expect(Reaction.new_reactions).not_to include(react2)
  end
end
