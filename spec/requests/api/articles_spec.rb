require "rails_helper"
include Rack::Test::Methods

RSpec.describe "Article API", :type => :request do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe 'anonymous user' do
    it "retrieves a specific article" do
      @article = FactoryGirl.create(:article)
      get "/articles/#{@article.id}"

      expect(response).to be_success
      expect(json['title']).to eq(@article.title)
    end

    it 'sends a list of articles' do
      FactoryGirl.create_list(:article, 10)
      get '/articles'

      expect(response).to be_success
      expect(json.length).to eq(10)
    end

    it "can't crete an article" do
      expect(Article.all.length).to eq(0)
      post "/articles/",
        :params => {:article => { :title => "new title",
                      :content => "new content" }, :email => @user.email}

      expect(response).to have_http_status(401)
      expect(Article.all.length).to eq(0)
    end
  end

  describe 'authenticated user' do

    it 'cretes an article' do
      expect(Article.all.length).to eq(0)
      post "/articles/",
        :params => {:article => { :title => "new title",
                      :content => "new content" }, :email => @user.email},
        :headers => {'Authorization' => get_token(@user)}

      expect(response).to have_http_status(201)
      expect(Article.all.length).to eq(1)
      expect(json['title']).to eq("new title")
      expect(json['content']).to eq("new content")
    end

    it 'deletes an article' do
      @article = FactoryGirl.create(:article, user_id: @user.id)
      expect(Article.all.length).to eq(1)
      delete "/articles/#{@article.id}", :headers => {'Authorization' => get_token(@user)}

      expect(response).to be_success
      expect(Article.all.length).to eq(0)
    end

    it "can't delete article if not author" do
      @article = FactoryGirl.create(:article)
      expect(Article.all.length).to eq(1)
      delete "/articles/#{@article.id}", :headers => {'Authorization' => get_token(@user)}

      expect(response).to have_http_status(422)
      expect(Article.all.length).to eq(1)
    end

    it 'updates an article by author' do
      @article = FactoryGirl.create(:article, user_id: @user.id)
      put "/articles/#{@article.id}", :params => {:id => @article.id,
        :article => { :title => "title updated",
                      :content => "content updated" }},
        :headers => {'Authorization' => get_token(@user)}

      expect(response).to have_http_status(201)
      expect(json['title']).to eq("title updated")
      expect(json['content']).to eq("content updated")
    end

    it "can't update article it not author" do
      @article = FactoryGirl.create(:article)
      put "/articles/#{@article.id}", :params => {:id => @article.id,
        :article => { :title => "title updated",
                      :content => "content updated" }},
        :headers => {'Authorization' => get_token(@user)}

      expect(response).to have_http_status(422)
    end

  end
end
