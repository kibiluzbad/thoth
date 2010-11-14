module Thoth

  # Representa um personagem.

  class Character
    include Attributes
    include AutoJ
    attr_accessor :actor, :name, :url, :picture_path, :imdbid

    # Construtor da class, pode receber um bloco inicializando os parametros ou um hash.

    def initialize(attributes=nil)
      yield self if block_given?
      assign_attributes(attributes) unless attributes.nil?
    end
  end
end

