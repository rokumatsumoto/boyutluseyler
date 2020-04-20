# == Schema Information
#
# Table name: users_roles
#
#  user_id :bigint(8)        not null
#  role_id :bigint(8)        not null
#

class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
