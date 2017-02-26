class Api::ArticleSerializer < ActiveModel::Serializer
  has_many :comments
  belongs_to :user
  attributes :id, :title, :content, :added,
              :count_comments, :comments, :user

  def count_comments
    object.comments.size
  end

  def added
    object.created_at.strftime('%v')
  end
end
