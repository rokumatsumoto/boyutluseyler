# == Schema Information
#
# Table name: design_downloads
#
#  id         :bigint(8)        not null, primary key
#  step       :string(50)
#  url        :string
#  design_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe DesignDownload, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
