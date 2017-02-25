class AddUserRefToArticles < ActiveRecord::Migration[5.0]
  def change
    add_reference :articles, :user, foreign_key: true, index: true
  end
end
