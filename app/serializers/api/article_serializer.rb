class Api::ArticleSerializer < ActiveModel::Serializer
  has_many :comments
  attributes :id, :title, :content, :count_comments, :comments

  def count_comments
    object.comments.size
  end
end
