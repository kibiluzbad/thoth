$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )

require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'haml'

require 'Thoth/Common'
require 'Thoth/Person'
require 'Thoth/AlternativeTitle'
require 'Thoth/Recommendation'
require 'Thoth/Character'
require 'Thoth/Director'
require 'Thoth/Writer'
require 'Thoth/Movie'
require 'Thoth/MovieInfo'
require 'Thoth/ImdbParser'
require 'Thoth/MovieSearchProvider'

set :environment, :production

helpers do
  def stylesheet_link_tag(name)
    "<link href='/css/#{name}.css' media='screen' rel='Stylesheet' type='text/css' />"
  end

  def javascript_link_tag(path)
    "<script src=\"#{path.include?('http') ? path : '/javascript/' + path + '.js'}\" type=\"text/javascript\"></script> "
  end

  def images_path(name)
    "/images/#{name}"
  end
end

get '/' do
  # matches "GET /"
  haml :index  
end

get %r{/movie/(tt[0-9]+)} do |imdbid|
  # matches "GET /movie/tt999999"
  # params[:imdbid] is a valid imdbid starting with 'tt'
  content_type :json
  movie = Thoth::ImdbMovieParser::new.parse(imdbid)
  movie.to_json
end

get '/search/:query' do
  # matches "GET /search/the%20matrix" or any other text
  # params[:query] is movie title to search
  content_type :json
  result = Thoth::MovieSearchProvider::search(params[:query])
  result.to_json
end

post '/search' do
  # matches "POST /search
  # params[:query] is movie title to search
  @query = params[:query]  
  @result = Thoth::MovieSearchProvider::search(@query)
  @result = @result.to_json
  haml :index  
end

post '/movie' do
  # matches "POST /movie
  # params[:imdbid] is a valid imdbid starting with 'tt'
  @imdbid = params[:imdbid]
  @result = Thoth::ImdbMovieParser::new.parse(@imdbid)
  @result = @result.to_json
  haml :index    
end

error do
  {:error => env['sinatra.error']}.to_json
end

