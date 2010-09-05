module Thoth
    
    # Classe de busca de filmes. A busca é feita atraves de um get a API de busca do Google
    # limitada ao http://imdb.com/. O resultado é armazenado em um SearchResult.
    
    class MovieSearchProvider
        @imdb_url = 'imdb.com'
        
        # Método de busca, recebe uma query contendo o nome do filme desejado e devolve um 
        # hash de SearchResult.
        
        def self.search(query)
            url = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{query}%20site:#{@imdb_url}"
            data = JSON.parse(open(url.gsub(/\s/,"%20")).read.to_s)
            result = []
            
            data["responseData"]["results"].map do |item|
                result.push(SearchResult.new do |sr|
                    sr.title = item["titleNoFormatting"]
                    sr.content = item["content"]
                    sr.url = item["url"]
                end)
            end
            
            result
        end        
    end
    
    # Representa um resultado de busca.
    
    class SearchResult
        include Attributes
        include AutoJ
        
        attr_accessor :title, :content, :url
        
        # Construtor da class, pode receber um bloco inicializando os parametros ou um hash.
        
        def initialize(attributes=nil)
            yield self if block_given?
            assign_attributes(attributes) unless attributes.nil?
        end
    end
end
