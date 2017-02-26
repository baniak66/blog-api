class Api::UserSerializer < ActiveModel::Serializer
  has_many :articles

  attributes :id, :email

end
