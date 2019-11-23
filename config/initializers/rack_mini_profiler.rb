Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore if Rails.env.development?
