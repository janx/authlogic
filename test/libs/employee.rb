class Employee
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :company_id, type: Integer
  field :email
  field :crypted_password
  field :password_salt
  field :persistence_token
  field :first_name
  field :last_name
  field :login_count, type: Integer, default: 0
  field :last_request_at, type: DateTime
  field :current_login_at, type: DateTime
  field :last_login_at, type: DateTime
  field :current_login_ip
  field :last_login_ip

  belongs_to :company

  include Authlogic::Mongoid
  acts_as_authentic do |c|
    c.crypto_provider Authlogic::CryptoProviders::AES256
  end
end
