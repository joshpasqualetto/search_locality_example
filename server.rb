require 'sinatra'
require 'ferret'
require 'json'
require_relative 'lib/search'

include Ferret

get '/' do
  'Healthy'
end

post '/search' do
  search_results = index.search(query(params[:search_terms], params[:slop]))
  return_results(search_results)
end
