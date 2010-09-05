module Thoth
    
    # Classe responsavel por criar um objeto Movie utilizando 
    # um MovieInfo.
    
    class ImdbMovieParser
        include MovieInfo
        
        # Efetua a criação do Movie recebendo como parametro o imdbid do filme.
        
        def parse(imdbid)
            
            url = 'http://www.imdb.com/title/' + imdbid + '/'
            doc = Nokogiri::HTML(open(url))do |config|
              config.noblanks
            end
            
            movie = Thoth::Movie::new do |m|
                m.imdbid = imdbid
                m.title, m.year = get_title_and_year(doc)
                m.directors = get_directors(doc)
                m.rating = get_rating(doc)
                m.genres = get_genres(doc)
                m.tagline = get_tagline(doc)
                m.plot = get_plot(doc)
                m.cast = get_cast(doc)
                m.runtime = get_runtime(doc)
                m.writers = get_writers(doc)
                m.recomendations = get_recomendations(doc)
            end
        end
    end   
end
