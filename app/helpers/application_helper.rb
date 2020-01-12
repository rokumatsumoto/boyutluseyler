# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  D_DESC = 'direction=desc'
  D_ASC = 'direction=asc'

  def human_enum_name(model, enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model.model_name.i18n_key}.#{enum_name}.#{enum_value}")
  end

  def human_enum_collection(model, enum_name)
    model.send(enum_name.to_s).keys.collect { |val| [human_enum_name(model, enum_name, val), val] }
  end

  # Check if a particular controller is the current one
  #
  # args - One or more controller names to check (using path notation when inside namespaces)
  #
  # Examples
  #
  #   # On TreeController
  #   current_controller?(:tree)           # => true
  #   current_controller?(:commits)        # => false
  #   current_controller?(:commits, :tree) # => true
  #
  #   # On Admin::ApplicationController
  #   current_controller?(:application)         # => true
  #   current_controller?('admin/application')  # => true
  #   current_controller?('boyutluseyler/application') # => false
  def current_controller?(*args)
    args.any? do |v|
      v.to_s.downcase == controller.controller_name || v.to_s.downcase == controller.controller_path
    end
  end

  # Check if a particular action is the current one
  #
  # args - One or more action names to check
  #
  # Examples
  #
  #   # On Projects#new
  #   current_action?(:new)           # => true
  #   current_action?(:create)        # => false
  #   current_action?(:new, :create)  # => true
  def current_action?(*args)
    args.any? { |v| v.to_s.downcase == action_name }
  end

  def active_class_for(query)
    request.fullpath.include?(query) ? true : false
  end

  def toggle_sort_link(link_path, active)
    return link_path unless active

    return link_path.gsub(D_DESC, D_ASC) if request.fullpath.include?(D_DESC)

    link_path.gsub(D_ASC, D_DESC)
  end
end
