# frozen_string_literal: true

class CleanupTmpCacheWorker
  include ApplicationWorker
  def perform
    $stdout.puts 'Running rake tmp:cache:clear'
    `rake tmp:cache:clear`
  end
end
