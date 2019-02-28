module I18nTranslationHelpers
  module_function

  # User translation helpers
  def not_found_message_for_email
    t('activerecord.errors.models.user.attributes.email.not_found')
  end

  def taken_message_for_email
    t('activerecord.errors.models.user.attributes.email.taken')
  end
end
