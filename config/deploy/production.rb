set :stage, :production
set :rails_env, :production
set :deploy_to, "/deploy/apps/blog_ruby_server"
server "3.0.99.39", user: "deploy", roles: %w(web app db)
