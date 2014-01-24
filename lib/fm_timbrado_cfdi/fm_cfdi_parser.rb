# -*- encoding : utf-8 -*-
require 'nokogiri'

module FmTimbradoCfdi
  class FmCfdiParser
    def initialize ( nodo_timbre )
      parse( nodo_timbre )
    end

    private
    def parse ( nodo_timbre )
      xml = Nokogiri::XML(nodo_timbre)
      ns = generar_namespaces(xml)
      atributos.each do |variable|
        instance_variable_set("@#{variable}", send("obtener_#{variable}", xml, ns))
      end
    end


    def generar_namespaces(xml)
      namespaces = xml.collect_namespaces
      ns = {}
      namespaces.each_pair do |key, value|
        ns[key.sub(/^xmlns:/, '')] = value
      end
      ns
    end
  end
end

