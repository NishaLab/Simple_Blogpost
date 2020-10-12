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
    expect(response.header["Content-Disposition"]).to eq("attachment; filename=\"export_#{user.id}.zip\";" +
                                                         " filename*=UTF-8''export_#{user.id}.zip")
    Zip::InputStream.open(StringIO.new(response.parsed_body())) do |io|
      while (entry = io.get_next_entry)
        binding.pry
        puts "Contents of #{entry.name}: '#{io.read}'"
      end
    end

  end
end
