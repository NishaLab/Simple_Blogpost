set :rails_env, :production
set :deploy_to, "/var/www/blog_ruby_server"
set :branch, :redeploy
server "3.0.100.238", user: "deploy", roles: %w(web app db)
