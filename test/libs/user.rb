class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :lock_version, type: Integer, default: 0
  field :company_id, type: Integer
  field :login
  field :crypted_password
  field :password_salt
  field :persistence_token
  field :single_access_token
  field :perishable_token
  field :email
  field :first_name
  field :last_name
  field :login_count, type: Integer, default: 0
  field :failed_login_count, type: Integer, default: 0
  field :last_request_at, type: DateTime
  field :current_login_at, type: DateTime
  field :current_login_ip
  field :last_login_ip
  field :active, type: Boolean, default: true
  field :approved, type: Boolean, default: true
  field :confirmed, type: Boolean, default: true

  belongs_to :company
  has_and_belongs_to_many :projects

  include Authlogic::Mongoid
  acts_as_authentic

end
