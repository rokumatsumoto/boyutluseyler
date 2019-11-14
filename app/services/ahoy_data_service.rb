# frozen_string_literal: true

class AhoyDataService
  attr_reader :event_name, :options

  def initialize(options)
    @event_name = options['event_name']
    @options = options
  end

  def execute
    properties
  end

  private

  def properties
    props = {}

    case event_name
    when *design_event_list
      props[:design_id] = options['design_id']
    end

    props
  end

  def design_event_list
    [
      'Downloaded design',
      'Liked design',
      'Saved design'
    ]
  end
end
