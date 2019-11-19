# frozen_string_literal: true

module AhoyActions
  # Ahoy.server_side_visits = :when_needed
  # We are using the above config so visits will be created server-side only when needed by events
  # In designs_controller.rb we track events named 'Viewed design' 'Downloaded design', 'Liked design' and 'Saved design'
  # 'Viewed design' event invoked synchronously, others invoked asynchronously
  # Ahoy uses 'request' object for accessing 'traffic source', 'technology', 'UTM parameters' etc. (https://api.rubyonrails.org/v6.0.0/classes/ActionDispatch/Request.html)
  # For asynchronous jobs, we cannot send this 'request' object to the Sidekiq (https://github.com/mperham/sidekiq/wiki/Best-Practices#1-make-your-job-parameters-small-and-simple)
  # https://github.com/ankane/ahoy/pull/409

  # In our scenario user must view the design before async jobs. (download, like, save) When the user views the design, a visit record will be created if 'visit_duration' (4.hours) time expired at that moment.
  # Users may visit the design very close to the end of the 'visit_duration', after that visit 'visit_duration' time may be expired. Clicking the download button creates a new visit record because 'visit_duration' time expired. This new visit record will contain missing data about 'traffic source', 'technology', 'UTM parameters' etc. because Ahoy will be unable to access 'request' object in the async job.
  # So we need to ensure a new visit is created in controller or service before async jobs.

  def ensure_new_visit_created_before_ahoy_async_jobs
    # https://github.com/ankane/ahoy/blob/6409f3152afa882659a02f95644e3ac928f7dcb6/lib/ahoy/controller.rb#L31
    ahoy.track_visit(defer: false) if ahoy.new_visit?
  end
end
