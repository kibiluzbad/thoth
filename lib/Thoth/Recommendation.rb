module Thoth

  # Filme recomendado.

  class Recommendation
    include Attributes
    include AutoJ
    attr_accessor :imdbid, :title, :url, :picture_path

    # Construtor da class, pode receber um bloco inicializando os parametros ou um hash.

    def initialize(attributes=nil)
      yield self if block_given?
      assign_attributes(attributes) unless attributes.nil?
    end
  end
end

