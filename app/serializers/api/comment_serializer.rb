class Api::CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
end
