# -*- encoding : utf-8 -*-
require 'nokogiri'

module FmTimbradoCfdi
  class FmTimbre
    attr_reader :no_certificado_sat, :fecha_timbrado, :uuid, :sello_sat, :sello_cfd, :fecha_comprobante, :serie, :folio, :trans_id

    def initialize ( nodo_timbre )
      parse( nodo_timbre )
    end

    def parse ( nodo_timbre )
      xml = Nokogiri::XML(nodo_timbre)
      ns = generar_namespaces(xml)
      atributos.each do |variable|
        instance_variable_set("@#{variable}", send("obtener_#{variable}", xml, ns))
      end
    end

    private

    def generar_namespaces(xml)
      namespaces = xml.collect_namespaces
      ns = {}
      namespaces.each_pair do |key, value|
        ns[key.sub(/^xmlns:/, '')] = value
      end
      ns
    end

    def atributos
      [ 'trans_id',
        'no_certificado_sat',
        'fecha_timbrado',
        'uuid',
        'sello_sat',
        'sello_cfd',
        'fecha_comprobante',
        'serie',
        'folio' ]
    end

    def obtener_trans_id(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('TransID').value rescue nil
    end

    def obtener_no_certificado_sat(xml, ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('noCertificadoSAT').value rescue nil
    end

    def obtener_uuid(xml,ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('UUID').value rescue nil
    end

    def obtener_fecha_timbrado(xml, ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('FechaTimbrado').value rescue nil
    end

    def obtener_sello_sat(xml, ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('selloSAT').value rescue nil
    end

    def obtener_fecha_comprobante(xml, ns)
      xml.xpath("//cfdi:Comprobante", ns).attribute('fecha').value rescue nil
    end

    def obtener_sello_cfd(xml, ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('selloCFD').value rescue nil
    end

    def obtener_serie(xml, ns )
      xml.xpath("//cfdi:Comprobante", ns).attribute('serie').value rescue nil
    end

    def obtener_folio(xml, ns)
      xml.xpath("//cfdi:Comprobante", ns).attribute('folio').value rescue nil
    end
  end
end

