sidekiq: bundle exec sidekiq -e $APP_ENV -C ./config/sidekiq.yml -r ./crontab.rb
sidekiq-web: bundle exec rackup config.ru -o 0.0.0.0 --env $APP_ENV
