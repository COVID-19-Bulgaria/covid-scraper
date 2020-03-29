# frozen_string_literal: true

require 'git'

class PublishDatasetsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, backtrace: true

  def perform
    git = Git.open(ENV['COVID_DATABASE_PATH_CONTAINER'])
    git.add(all: true)
    current_date_time = Time.now.strftime('%d.%m.%Y %H:%M')

    git.commit("Data scraped automatically for #{current_date_time}")
    git.push
  rescue Git::GitExecuteError => e
    puts e.message
  end
end
