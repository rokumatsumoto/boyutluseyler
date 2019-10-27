# frozen_string_literal: true

Sidekiq::Worker.extend ActiveSupport::Concern

module ApplicationWorker
  extend ActiveSupport::Concern

  include Sidekiq::Worker
end
