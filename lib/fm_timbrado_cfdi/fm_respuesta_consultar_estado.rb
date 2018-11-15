# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'savon'
require 'fm_timbrado_cfdi/fm_respuesta_consultar_estado_parser'

module FmTimbradoCfdi
  class FmRespuestaConsultarEstado
    attr_reader :xml

    def initialize(savon_response)
      @respuesta = savon_response
      @xml = @respuesta.to_xml
      @parsed_response = parsear_respuesta
    end

    def codigo_error
      @parsed_response.codigo_error
    end

    def mensaje_error
      @parsed_response.mensaje_error
    end

    def http_code
      @parsed_response.http_code
    end

    def estado
      @parsed_response.estado
    end

    def es_cancelable
      @parsed_response.es_cancelable
    end

    def estatus_cancelacion
      @parsed_response.estatus_cancelacion
    end

    def valid?
      @respuesta.success?
    end

    private

    def parsear_respuesta
      FmTimbradoCfdi::FmRespuestaConsultarEstadoParser.new(xml)
    end
  end
end
