require "rails_helper"
include Rack::Test::Methods

RSpec.describe "Article API", :type => :request do

  let(:user) { create :user }
  let(:article) { create :article }

  describe 'anonymous user' do
    it "retrieves a specific article" do
      get "/articles/#{article.id}"

      expect(response).to be_success
      expect(json['title']).to eq(article.title)
    end

    context 'retrives list' do
      let!(:articles) { create_list :article, 10 }
      it 'of articles' do
        get '/articles'

        expect(response).to be_success
        expect(json.length).to eq(10)
      end
    end

    it "can't crete an article" do
      expect(Article.all.length).to eq(0)
      post "/articles/",
        :params => {:article => { :title => "new title",
                      :content => "new content" }, :email => user.email}

      expect(response).to have_http_status(401)
      expect(Article.all.length).to eq(0)
    end
  end

  describe 'authenticated user' do

    it 'cretes an article' do
      expect(Article.all.length).to eq(0)
      post "/articles/",
        :params => {:article => { :title => "new title",
                      :content => "new content" }, :email => user.email},
        :headers => {'Authorization' => get_token(user)}

      expect(response).to have_http_status(201)
      expect(Article.all.length).to eq(1)
      expect(json['title']).to eq("new title")
      expect(json['content']).to eq("new content")
    end

    context 'author' do
      let!(:article) { create :article, user_id: user.id }
      it 'deletes article' do
        expect(Article.all.length).to eq(1)
        delete "/articles/#{article.id}", :headers => {'Authorization' => get_token(user)}

        expect(response).to be_success
        expect(Article.all.length).to eq(0)
      end
    end

    context 'not author' do
      let!(:article) { create :article }
      it "can't delete article if not author" do
        expect(Article.all.length).to eq(1)
        delete "/articles/#{article.id}", :headers => {'Authorization' => get_token(user)}

        expect(response).to have_http_status(422)
        expect(Article.all.length).to eq(1)
      end
    end

    context 'author' do
      let!(:article) { create :article, user_id: user.id }
      it 'updates an article by author' do
        put "/articles/#{article.id}", :params => {:id => article.id,
          :article => { :title => "title updated",
                        :content => "content updated" }},
          :headers => {'Authorization' => get_token(user)}

        expect(response).to have_http_status(201)
        expect(json['title']).to eq("title updated")
        expect(json['content']).to eq("content updated")
      end
    end

    context 'not author' do
      let!(:article) { create :article }
      it "can't update article it not author" do
        put "/articles/#{article.id}", :params => {:id => article.id,
          :article => { :title => "title updated",
                        :content => "content updated" }},
          :headers => {'Authorization' => get_token(user)}

        expect(response).to have_http_status(422)
      end
    end

  end
end
