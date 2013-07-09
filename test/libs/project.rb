class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :name

  has_and_belongs_to_many :users
end
