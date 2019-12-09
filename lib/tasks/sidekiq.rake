namespace :sidekiq do
  require 'sidekiq/api'

  desc "Wait until 'busy' queue is finished"
  task wait: :environment do
    Sidekiq::ProcessSet.new.each(&:quiet!)
    sleep(1) until finished?
  end

  private

  def finished?
    ps = Sidekiq::ProcessSet.new
    ps.empty? || ps.detect { |process| process['busy'] == 0 }
  end
end
