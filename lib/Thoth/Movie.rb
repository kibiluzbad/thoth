module Thoth
    
    # Classe que representa um filme.
    
    class Movie
       include Attributes
       include AutoJ
        attr_accessor :imdbid, :title, :directors, :writers, :rating, :genres, :tagline, :plot, :cast, :year, :runtime, :recomendations
       
        # Construtor da class, pode receber um bloco inicializando os parametros ou um hash.
       
        def initialize(attributes=nil)
            yield self if block_given?
            assign_attributes(attributes) unless attributes.nil?
        end  
        
        
    end
end
