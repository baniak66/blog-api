class Api::UserSerializer < ActiveModel::Serializer
  has_many :articles
  has_many :comments

  attributes :id, :email

end
