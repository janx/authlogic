class Affiliate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :company_id, type: Integer
  field :username
  field :pw_hash
  field :pw_salt
  field :persistence_token

  belongs_to :company

  include Authlogic::Mongoid
  acts_as_authentic do |c|
    c.crypted_password_field = :pw_hash
  end

end
