module Api
  class CommentsController < ApplicationController
    before_action :set_article

    def index
      @article = Article.find(params[:article_id])
      @comments = @article.comments
      render json: @comments
    end

    def create
      @comment = @article.comments.create(comment_params)
      if @comment.save
        render json: @comment, status: 201
      else
        render json: { errors: @comment.errors }, status: 422
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_article
      @article = Article.find(params[:article_id])
    end
  end
end
