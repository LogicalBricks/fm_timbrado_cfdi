module FmTimbradoCfdi
  class FmCfdi
    attr_reader :xml
    def initialize(response)
      @doc = Nokogiri::XML(response)
      @xml = obtener_xml(@doc)
    end

    def is_version_3_2?
      obtener_version('version') == '3.2'
    end

    def is_version_3_3?
      obtener_version('Version') == '3.3'
    end

    private

    def obtener_version(version)
      begin
        factura_xml = Nokogiri::XML(xml)
        factura_xml.xpath("//cfdi:Comprobante").attribute(version).value
      rescue
        nil
      end
    end

    def obtener_xml(doc)
      unless doc.xpath("//xml").empty? then
        Base64::decode64 doc.xpath("//xml")[0].content
      else
        nil
      end
    end
  end
end
