# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'savon'

module FmTimbradoCfdi
  class FmRespuestaCancelacion
    attr_reader :errors
    def initialize(savon_response)
      @respuesta = savon_response
      if not valid?
        #@error = @respuesta.http_error.to_s if @respuesta.http_error?
        @error = @respuesta.soap_fault.to_s if @respuesta.soap_fault?
      end
    end

    def codigo
      @error.match(/\((.*)\).*/)[0] if @error
    end

    def mensaje
      @error
    end

    def valid?
      @respuesta.success?
    end

  end
end
