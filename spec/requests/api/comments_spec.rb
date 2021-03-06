require "rails_helper"
include Rack::Test::Methods

RSpec.describe "Comment API", :type => :request do

  let(:user) { create :user }
  let(:article) { create :article }

  describe "anonymous user" do
    it "can't add comment" do
      expect(article.comments.all.length).to eq(0)
      post "/articles/#{article.id}/comments",
          :params => {:comment => { :content => "new content" },
                      :email => user.email}

      expect(response).to have_http_status(401)
      expect(article.comments.all.length).to eq(0)
    end
  end

  describe "authenticated user" do
    it "creates a comment" do
      expect(article.comments.all.length).to eq(0)
      post "/articles/#{article.id}/comments",
          :params => {:comment => { :content => "new content" },
                      :email => user.email},
          :headers => {'Authorization' => get_token(user)}

      expect(response).to have_http_status(201)
      expect(article.comments.all.length).to eq(1)
    end
  end
end
