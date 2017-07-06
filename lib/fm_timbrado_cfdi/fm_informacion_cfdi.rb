# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'fm_timbrado_cfdi/fm_cfdi_parser'

module FmTimbradoCfdi
  class FmInformacionCfdi < FmCfdiParser
    attr_reader :total, :subtotal, :descuento

private
    def atributos
      [ 'total',
        'subtotal',
        'descuento',
      ]
    end

    def obtener_total(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('total').value rescue nil
    end

    def obtener_subtotal(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('subTotal').value rescue nil
    end

    def obtener_descuento(xml,ns)
      xml.xpath("//cfdi:Comprobante",ns).attribute('descuento').value rescue nil
    end


  end
end

