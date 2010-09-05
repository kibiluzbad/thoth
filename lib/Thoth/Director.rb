module Thoth
    
    # Representa um diretor.
    
    class Director
        
        include Attributes
        include AutoJ
        
        attr_accessor :name, :url

        # Construtor da class, pode receber um bloco inicializando os parametros ou um hash.

        def initialize(attributes=nil)
            yield self if block_given?
            assign_attributes(attributes) unless attributes.nil?
        end            
    end
end
