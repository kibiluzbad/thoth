$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )

require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'Thoth/Common'
require 'Thoth/Character'
require 'Thoth/Director'
require 'Thoth/Movie'
require 'Thoth/MovieInfo'
require 'Thoth/ImdbParser'
require 'Thoth/MovieSearchProvider'

get '/' do
    # matches "GET /"
    'Thoth is on line!'
end

get '/movie/:imdbid' do
    # TODO: Create regex to validate imdbid
    # matches "GET /movie/tt999999"
    # params[:imdbid] is a valid imdbid starting with 'tt'
    content_type :json
    movie = Thoth::ImdbMovieParser::new.parse(params[:imdbid])
    movie.to_json
end

get '/search/:query' do
    # matches "GET /search/the%20matrix" or any other text
    # params[:query] is movie title to search
    content_type :json
    result = Thoth::MovieSearchProvider::search(params[:query])
    result.to_json
end
