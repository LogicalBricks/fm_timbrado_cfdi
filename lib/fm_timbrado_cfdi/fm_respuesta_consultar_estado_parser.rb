# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'fm_timbrado_cfdi/fm_cfdi_parser'

module FmTimbradoCfdi
  class FmRespuestaConsultarEstadoParser < FmCfdiParser
    attr_reader :http_code, :estado, :es_cancelable, :estatus_cancelacion,
      :codigo_error, :mensaje_error

    private

      def atributos
        ['http_code',
         'estado',
         'es_cancelable',
         'estatus_cancelacion',
         'codigo_error',
         'mensaje_error']
      end

      def obtener_estado(xml, ns)
        xml.xpath('//estado', ns).text.strip rescue nil
      end 

      def obtener_http_code(xml, ns)
        xml.xpath('//http_code', ns).text.strip rescue nil
      end 

      def obtener_es_cancelable(xml, ns)
        xml.xpath('//esCancelable', ns).text.strip rescue nil
      end 

      def obtener_estatus_cancelacion(xml, ns)
        xml.xpath('//estatusCancelacion', ns).text.strip rescue nil
      end 

      def obtener_codigo_error(xml, ns)
        xml.xpath('//faultcode', ns).text.strip rescue nil
      end 

      def obtener_mensaje_error(xml, ns)
        xml.xpath('//faultstring', ns).text.strip rescue nil
      end

  end
end
