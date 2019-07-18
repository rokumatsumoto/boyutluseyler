# frozen_string_literal: true

module ApplicationHelper
  def human_enum_name(model, enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model.model_name.i18n_key}.#{enum_name}.#{enum_value}")
  end

  def human_enum_collection(model, enum_name)
    model.send(enum_name.to_s).keys.collect { |val| [human_enum_name(model, enum_name, val), val] }
  end
end
