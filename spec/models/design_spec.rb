# == Schema Information
#
# Table name: designs
#
#  id                :bigint(8)        not null, primary key
#  name              :string(120)      not null
#  description       :text             not null
#  printing_settings :text
#  model_file_format :string
#  license_type      :string           not null
#  allow_comments    :boolean          default(TRUE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint(8)        not null
#  category_id       :bigint(8)        not null
#

require 'rails_helper'

RSpec.describe Design, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
