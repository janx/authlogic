class Ldaper
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :ldap_login
  field :persistence_token

  include Authlogic::Mongoid
  acts_as_authentic
end
