module BackgroundJobs
  def run_background_jobs_immediately
    # https://github.com/mperham/sidekiq/wiki/Testing
    Sidekiq::Testing.inline!
    yield
    Sidekiq::Testing.fake!
  end
end
