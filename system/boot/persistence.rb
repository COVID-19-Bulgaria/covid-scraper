# frozen_string_literal: true

CovidScraper::Application.boot(:persistence) do |app|
  start do
    config = app['db.config']
    config.auto_registration(app.root + 'lib/covid_scraper')

    register('container', ROM.container(app['db.config']))
  end
end
