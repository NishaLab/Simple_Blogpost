Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth_2,
           ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], skip_jwt: true
end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"]
end
