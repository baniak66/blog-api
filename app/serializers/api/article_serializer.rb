class Api::ArticleSerializer < ActiveModel::Serializer
  has_many :comments
  belongs_to :user
  attributes :id, :title, :content, :added,
              :count_comments, :comments, :email

  def count_comments
    object.comments.size
  end

  def email
    object.user.email
  end

  def added
    object.created_at.strftime('%v')
  end
end
