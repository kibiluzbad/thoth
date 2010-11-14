module Thoth

  # Modulo com metodos auxiliares para atributos de classes.

  module Attributes

    # Método para inicialização de atributos atravez de um hash.

    def assign_attributes(attributes={})
      attributes.each do |k, v|
        respond_to?("#{k}=") ? send("#{k}=", v) : raise(ScriptError, "unknown attribute: #{k}")
      end
    end
  end

  # Modulo para conversão de objetos em json.

  module AutoJ

    # Mapea os atributos em um hash.

    def auto_j
      h = {}
      instance_variables.each do |e|
        o = instance_variable_get e.to_sym
        h[e[1..-1]] = (o.respond_to? :auto_j) ? o.auto_j : o;
      end
      h
    end

    # Converte para json.

    def to_json *a
      auto_j.to_json *a
    end
  end
end

