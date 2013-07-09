class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :name
  field :active, type: Boolean

  has_many :employees, :dependent => :destroy
  has_many :users, :dependent => :destroy

  include Authlogic::Mongoid
  authenticates_many :employee_sessions
  authenticates_many :user_sessions
end
