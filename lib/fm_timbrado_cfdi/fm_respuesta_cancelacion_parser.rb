# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'fm_timbrado_cfdi/fm_cfdi_parser'

module FmTimbradoCfdi
  class FmRespuestaCancelacionParser < FmCfdiParser
    attr_reader :codigo_error, :mensaje_error, :codigo, :mensaje

    private
      def atributos
        ['codigo_error',
         'mensaje_error',
         'codigo',
         'mensaje']
      end

      def obtener_codigo_error(xml, ns)
        xml.xpath('//faultcode', ns).text.strip rescue nil
      end 

      def obtener_mensaje_error(xml, ns)
        xml.xpath('//faultstring', ns).text.strip rescue nil
      end

      def obtener_codigo(xml, ns)
        xml.xpath('//Code', ns).text.strip rescue nil
      end

      def obtener_mensaje(xml, ns)
        xml.xpath('//Message', ns).text.strip rescue nil
      end
  end
end
