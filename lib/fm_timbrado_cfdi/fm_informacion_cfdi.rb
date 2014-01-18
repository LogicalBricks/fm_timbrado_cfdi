# -*- encoding : utf-8 -*-
require 'nokogiri'

module FmTimbradoCfdi
  class FmInformacionCfdi
    attr_reader :total, :subtotal, :descuento

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

    def atributos
      [ 'total',
        'subtotal',
        'descuento',
      ]
    end

    def obtener_total(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('total').value rescue nil
    end

    def obtener_subtotal(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('subTotal').value rescue nil
    end

    def obtener_descuento(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('descuento').value rescue nil
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

