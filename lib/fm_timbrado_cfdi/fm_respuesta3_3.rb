require "fm_timbrado_cfdi/fm_respuesta"
require 'fm_timbrado_cfdi/fm_timbre3_3'

module FmTimbradoCfdi
  class FmRespuesta3_3 < FmRespuesta

    def obtener_timbre(xml)
      FmTimbre3_3.new(xml) if xml
    end

    def obtener_no_csd_emisor(xml)
      begin
        factura_xml = Nokogiri::XML(xml)
        factura_xml.xpath("//cfdi:Comprobante").attribute('NoCertificado').value
      rescue Exception => e
        @errors << "No se ha podido obtener el CSD del emisor"
        nil
      end
    end
  end
end
