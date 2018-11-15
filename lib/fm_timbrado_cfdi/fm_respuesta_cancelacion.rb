# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'savon'
require 'fm_timbrado_cfdi/fm_respuesta_cancelacion_parser'

module FmTimbradoCfdi
  class FmRespuestaCancelacion
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

    def codigo
      @parsed_response.codigo
    end

    def mensaje
      @parsed_response.mensaje
    end

    def valid?
      @respuesta.success?
    end

    private

    def parsear_respuesta
      FmTimbradoCfdi::FmRespuestaCancelacionParser.new(xml)
    end
  end
end
