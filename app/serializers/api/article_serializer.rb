class Api::ArticleSerializer < ActiveModel::Serializer
  has_many :comments
  attributes :id, :title, :content, :created_at
              :count_comments, :comments, :author

  def count_comments
    object.comments.size
  end

  def author
    object.user.email
  end
end
