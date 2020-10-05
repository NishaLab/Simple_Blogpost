require "rails_helper"

RSpec.describe Reaction, type: :model do

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
end
