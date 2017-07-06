# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'fm_timbrado_cfdi/fm_cfdi_parser'

module FmTimbradoCfdi
  class FmTimbre < FmCfdiParser
    attr_reader :no_certificado_sat, :no_certificado, :fecha_timbrado, :uuid, :sello_sat, :sello_cfd, :fecha_comprobante, :serie, :folio, :trans_id, :version


    def cadena_original
      "||#{version}|#{uuid}|#{fecha_timbrado}|#{sello_cfd}|#{no_certificado_sat}||"
    end

    private

    def atributos
      [ 'trans_id',
        'version',
        'no_certificado_sat',
        'no_certificado',
        'fecha_timbrado',
        'uuid',
        'sello_sat',
        'sello_cfd',
        'fecha_comprobante',
        'serie',
        'folio' ]
    end

    def obtener_version(xml,ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('version').value rescue nil
    end

    def obtener_no_certificado(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('noCertificado').value rescue nil
    end

    def obtener_trans_id(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('TransID').value rescue nil
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

