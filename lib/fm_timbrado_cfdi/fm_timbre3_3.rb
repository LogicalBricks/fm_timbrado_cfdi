require 'fm_timbrado_cfdi/fm_timbre'

module FmTimbradoCfdi
  class FmTimbre3_3 < FmTimbre
    def obtener_version(xml,ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('Version').value rescue nil
    end

    def obtener_no_certificado(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('NoCertificado').value rescue nil
    end

    def obtener_no_certificado_sat(xml, ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('NoCertificadoSAT').value rescue nil
    end

    def obtener_sello_sat(xml, ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('SelloSAT').value rescue nil
    end

    def obtener_fecha_comprobante(xml, ns)
      xml.xpath("//cfdi:Comprobante", ns).attribute('Fecha').value rescue nil
    end

    def obtener_sello_cfd(xml, ns)
      xml.xpath("//tfd:TimbreFiscalDigital", ns).attribute('SelloCFD').value rescue nil
    end

    def obtener_serie(xml, ns )
      xml.xpath("//cfdi:Comprobante", ns).attribute('Serie').value rescue nil
    end

    def obtener_folio(xml, ns)
      xml.xpath("//cfdi:Comprobante", ns).attribute('Folio').value rescue nil
    end
  end
end

