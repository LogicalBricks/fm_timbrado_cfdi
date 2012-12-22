require "fm_timbrado_cfdi/version"
require "fm_timbrado_cfdi/fm_cliente"
require 'nokogiri'
require 'base64'

module FmTimbradoCfdi
  extend self

  def configurar
    yield cliente
  end

  def cliente 
    @cliente ||= FmCliente.new
  end

  #Envía un archivo xml al PAC para ser timbrado
  #Regresa un objeto tipo PACResponse que contiene el xml certificado, el timbre y la representación en pdf o el cbb en png
  # * <tt>xml</tt> - Es el archivo xml a ser timbrado como un string
  # * <tt>generar_cbb</tt> - Es una bandera que indica si debe generarse el código cbb, si se genera el cbb no se genera el pdf, por default es false
  def timbra_cfdi_xml (xml, generar_cbb = false)
    factura_xml = Nokogiri::XML(xml)
    #procesar rfc del emisor
    emisor = factura_xml.xpath("//cfdi:Emisor")
    rfc = emisor[0]['rfc']
    respuesta = cliente.peticion_timbrar rfc, factura_xml.to_s, generar_cbb
  end

  #Envía un archivo al PAC para ser timbrado en formato layout
  #Regresa un objeto tipo PACResponse que contiene el xml certificado, el timbre y la representación en pdf o el cbb en png
  # * <tt>layout</tt> - Es el archivo layout a ser timbrado como un string
  # * <tt>generar_cbb</tt> - Es una bandera que indica si debe generarse el código cbb, si se genera el cbb no se genera el pdf, por default es false
  def timbra_cfdi_layout (rfc, layout, generar_cbb = false)
    respuesta = cliente.peticion_timbrar rfc, layout, generar_cbb
  end

  #no implementado todavía
  def cancela_cfdi (uuid)
  end

  def nuevo_cliente
    Cliente.new
  end

  #:private_method nuevo_cliente

end
