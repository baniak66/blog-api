module Api
  class CommentsController < ApplicationController
    def index
      @article = Article.find(params[:article_id])
      @comments = @article.comments
      render json: @comments
    end
  end
end
