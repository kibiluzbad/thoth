module Thoth
	class Person
		include Attributes
        include AutoJ

		attr_accessor :imdbid, :name, :url
		
		# Construtor da class, pode receber um bloco inicializando os parametros ou um hash.

        def initialize(attributes=nil)
            yield self if block_given?
            assign_attributes(attributes) unless attributes.nil?
        end
	end
end
