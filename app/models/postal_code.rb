class PostalCode
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :number, :integer
end