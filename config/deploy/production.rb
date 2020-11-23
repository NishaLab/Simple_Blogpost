set :rails_env, :production
set :deploy_to, "/var/www/blog_ruby_server"
set :branch, :redeploy
server "54.169.254.235", user: "deploy", roles: %w(web app db)
