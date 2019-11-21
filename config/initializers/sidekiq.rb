schedule_file = 'config/schedule.yml'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{Boyutluseyler.credentials[:redis][:host]}:#{Boyutluseyler.credentials[:redis][:port]}/12" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{Boyutluseyler.credentials[:redis][:host]}:#{Boyutluseyler.credentials[:redis][:port]}/12" }
end

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
