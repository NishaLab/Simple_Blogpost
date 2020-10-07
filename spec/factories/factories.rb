FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "emailtest-#{n}@gmail.com" }
    password { "12345678" }
    password_confirmation { "12345678" }
    name {"hung1234"}
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :micropost do
    user
    content {"asfasd"}
    user_id {user.id}
  end

  factory :reaction do
    user
    micropost
    image_id {"1"}
    user_id {user.id}
    micropost_id {micropost.id}
  end
end
