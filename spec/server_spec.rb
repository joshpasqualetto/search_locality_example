require_relative '../server.rb'
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'Stelligent Proximity text search' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'Should respond with 200 OK' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'Posts a query with dog + fox and a slop of 0' do
    post '/search', search_terms: 'dog,fox', slop: 0
    json = JSON.parse(last_response.body)
    expect(last_response).to be_ok
    expect(json.first['filename']).to eq 'sample_docs/one.txt'
    expect(json.count).to eq 1
  end

  it 'Posts a query with fox + dog and a slop of 3' do
    post '/search', search_terms: 'fox,dog', slop: 3
    json = JSON.parse(last_response.body)
    expect(last_response).to be_ok
    expect(json[2]['filename']).to eq 'sample_docs/three.txt'
    expect(json.count).to eq 4
  end

  it 'Posts a phrase query with Dr. Fowler + Continuous Delivery and a slop of 3' do # rubocop:disable Metrics/LineLength
    post '/search', search_terms: 'Dr. Fowler,Continuous Delivery', slop: 3
    json = JSON.parse(last_response.body)
    expect(last_response).to be_ok
    expect(json.first['filename']).to eq 'sample_docs/extra_credit.txt'
    expect(json.count).to eq 1
  end

  it 'Posts a phrase query with Dr. Fowler + Continuous Delivery and a slop of 99' do # rubocop:disable Metrics/LineLength
    post '/search', search_terms: 'Dr. Fowler,Continuous Delivery', slop: 99
    json = JSON.parse(last_response.body)
    expect(last_response).to be_ok
    expect(json[1]['filename']).to eq 'sample_docs/extra_credit_long.txt'
    expect(json.count).to eq 2
  end
end
