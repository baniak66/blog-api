require "rails_helper"

RSpec.describe "Article API", :type => :request do

  it "retrieves a specific message" do
    article = FactoryGirl.create(:article)
    get "/articles/#{article.id}"

    expect(response).to be_success
    expect(json['title']).to eq(article.title)
  end

  it 'sends a list of articles' do
    FactoryGirl.create_list(:article, 10)
    get '/articles'

    expect(response).to be_success
    expect(json.length).to eq(10)
  end

  it 'cretes an article' do
    expect(Article.all.length).to eq(0)
    post "/articles/",
      :article => { :title => "new title",
                    :content => "new content" }
    expect(response).to have_http_status(201)
    expect(Article.all.length).to eq(1)
    expect(json['title']).to eq("new title")
    expect(json['content']).to eq("new content")
  end

  it 'deletes an article' do
    article = FactoryGirl.create(:article)
    expect(Article.all.length).to eq(1)

    delete "/articles/#{article.id}"

    expect(response).to be_success
    expect(Article.all.length).to eq(0)
  end

  it 'updates an article' do
    article = FactoryGirl.create(:article)
    put "/articles/#{article.id}", :id => article.id,
      :article => { :title => "title updated",
                    :content => "content updated" }
    expect(response).to have_http_status(201)
    expect(json['title']).to eq("title updated")
    expect(json['content']).to eq("content updated")
  end

end
