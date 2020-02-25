# == Schema Information
#
# Table name: users_roles
#
#  user_id :bigint(8)
#  role_id :bigint(8)
#

class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
