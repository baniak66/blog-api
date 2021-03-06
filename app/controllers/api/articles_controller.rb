module Api
  class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :update, :destroy]
    before_action :check_author, only: [:update, :destroy]
    before_action :authenticate_user, except: [:index, :show]

    def index
      @articles = Article.all
      render json: @articles
    end

    def show
      render json: @article
    end

    def create
      @user = User.find_by_email(params[:email])
      @article = @user.articles.create(article_params)
      if @article.save
        render json: @article, status: 201
      else
        render json: { errors: @article.errors }, status: 422
      end
    end

    def update
      if @article.update(article_params)
        render json: @article, status: 201
      else
        render json: { errors: @article.errors }, status: 422
      end
    end

    def destroy
      @articles = Article.all
      if @article.destroy
        render json: @article
      end
    end

  private

    def article_params
      params.require(:article).permit(:title, :content, :email)
    end

    def set_article
      @article = Article.find(params[:id])
    end

    def check_author
      unless @article.user.email === current_user.email
        render json: { errors: 'only author can perform this action' }, status: 422
      end
    end
  end
end
