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
      @error = false
      @errors = []
      begin
        if savon_response.success? then
          @doc = Nokogiri::XML(savon_response.to_xml)
          obtener_xml(@doc)
          obtener_timbre(@doc)
          obtener_pdf(@doc)
          obtener_cbb(@doc)
        else
          @error = true
          @errors << savon_response.soap_fault.to_s if savon_response.soap_fault.present?
          @pdf = nil
          @xml = nil
          @cbb = nil
          @timbre = nil
          @no_csd_emisor = nil
        end

      rescue Exception => e
        @error = true
        @errors << "No se ha podido realizar el parseo de la respuesta. #{e.message}"
      end
    end #parse

    def valid?
      not @error
    end

    def xml?
      not @xml.nil?
    end
    alias :xml_present? :xml?

    def cbb?
      not @cbb.nil?
    end
    alias :cbb_present? :cbb?

    def pdf?
      not @pdf.nil?
    end
    alias :pdf_present? :pdf?

    def timbre?
      not @timbre.nil?
    end
    alias :timbre_present? :timbre?

    def no_csd_emisor?
      not @no_csd_emisor.nil?
    end
    alias :no_csd_emisor_present? :no_csd_emisor?

    private

    def obtener_xml(doc)
      if not doc.xpath("//xml").empty? then
        @xml = Base64::decode64 doc.xpath("//xml")[0].content
        # tratamos de obtener el no de serie del CSD del emisor
        begin
          factura_xml = Nokogiri::XML(@xml)
          @no_csd_emisor = factura_xml.xpath("//cfdi:Comprobante").attribute('noCertificado').value
        rescue Exception => e
          @no_csd_emisor = nil
          @error = true
          @errors << "No se ha podido obtener el CSD del emisor"
        end
      else
        @xml = nil
        @error = true
        @errors << "No se ha encontrado el nodo xml"
      end
    end

    def obtener_timbre(doc)
      unless doc.xpath("//txt").empty?
        @timbre = FmTimbre.new Base64::decode64( doc.xpath("//txt")[0].content )
      else
        @timbre = nil
      end
    end

    def obtener_pdf(doc)
      unless doc.xpath("//pdf").empty?
        @pdf = Base64::decode64 doc.xpath("//pdf")[0].content
      else
        @pdf = nil
      end
    end

    def obtener_cbb(doc)
      unless doc.xpath("//png").empty?
        @cbb = Base64::decode64 doc.xpath("//png")[0].content
      else
        @cbb = nil
      end
    end
  end
end
