class User < ApplicationRecord
  has_and_belongs_to_many :roles

  def has_role(role_name)
    roles.where(name: role_name).exists?
  end
end
