# frozen_string_literal: true

module DesignsHelper
  def license_title_for(design)
    # TODO: i18n
    return 'Telif Hakkı' if design.license_type == 'license_none'

    'Lisans'
  end
end
