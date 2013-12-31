# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'savon'
require 'fm_timbrado_cfdi/fm_timbre'

module FmTimbradoCfdi
  class FmRespuesta
    attr_reader :errors, :pdf, :xml, :cbb, :timbre, :no_csd_emisor
    def initialize(savon_response)
      parse(savon_response)
    end

    def parse (savon_response)
      @errors = []
      begin
        if savon_response.success? then
          @doc = Nokogiri::XML(savon_response.to_xml)
          @xml = obtener_xml(@doc)
          @no_csd_emisor = obtener_no_csd_emisor(@xml) if @xml
          @timbre = obtener_timbre(@xml)
          @pdf = obtener_pdf(@doc)
          @cbb = obtener_cbb(@doc)
        else
          @errors << savon_response.soap_fault.to_s if savon_response.soap_fault?
          @doc = @xml = @no_csd_emisor = @timbre = @pdf = @cbb = nil
        end
      rescue Exception => e
        @errors << "No se ha podido realizar el parseo de la respuesta. #{e.message}"
      end
    end

    def valid?
      @errors.empty?
    end

    def xml?
      !!@xml
    end
    alias :xml_present? :xml?

    def cbb?
      !!@cbb
    end
    alias :cbb_present? :cbb?

    def pdf?
      !!@pdf
    end
    alias :pdf_present? :pdf?

    def timbre?
      !!@timbre
    end
    alias :timbre_present? :timbre?

    def no_csd_emisor?
      !!@no_csd_emisor
    end
    alias :no_csd_emisor_present? :no_csd_emisor?

    private

    def obtener_xml(doc)
      unless doc.xpath("//xml").empty? then
        Base64::decode64 doc.xpath("//xml")[0].content
      else
        @errors << "No se ha encontrado el nodo xml"
        nil
      end
    end

    def obtener_timbre(xml)
      FmTimbre.new(xml) if xml
    end

    def obtener_pdf(doc)
      unless doc.xpath("//pdf").empty?
        Base64::decode64 doc.xpath("//pdf")[0].content
      end
    end

    def obtener_cbb(doc)
      unless doc.xpath("//png").empty?
        Base64::decode64 doc.xpath("//png")[0].content
      end
    end

    def obtener_no_csd_emisor(xml)
      begin
        factura_xml = Nokogiri::XML(xml)
        factura_xml.xpath("//cfdi:Comprobante").attribute('noCertificado').value
      rescue Exception => e
        @errors << "No se ha podido obtener el CSD del emisor"
        nil
      end
    end
  end
end
