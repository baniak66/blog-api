class Api::CommentSerializer < ActiveModel::Serializer
  belongs_to :user

  attributes :id, :content, :added, :email

  def email
    object.user.email
  end

  def added
    object.created_at.strftime('%F')
  end
end
