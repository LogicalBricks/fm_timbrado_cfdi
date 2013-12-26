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

  # Public: Envía un archivo al PAC para ser timbrado en formato xml
  #
  # xml - Es el archivo XML sellado como un string
  # generar_cbb - Es una bandera que indica si debe generarse el código cbb, por default es false
  #
  # Regresa un objeto tipo FMRespuesta que contiene el xml certificado, el timbre y la representación en pdf o el cbb en png
  def timbra_cfdi_xml (xml, generar_cbb = false)
    factura_xml = Nokogiri::XML(xml)
    #procesar rfc del emisor
    emisor = factura_xml.xpath("//cfdi:Emisor")
    rfc = emisor[0]['rfc']
    respuesta = cliente.timbrar rfc, factura_xml.to_s, 'generarCBB' => generar_cbb
  end

  # Public: Envía un archivo al PAC para ser timbrado en formato layout
  #
  # rfc - Es el RFC del emisor
  # layout - Es el archivo layout a ser timbrado como un string
  # generar_cbb - Es una bandera que indica si debe generarse el código cbb, por default es false
  #
  # Regresa un objeto tipo FMRespuesta que contiene el xml certificado, el timbre y la representación en pdf o el cbb en png
  def timbra_cfdi_layout (rfc, layout, generar_cbb = false)
    respuesta = cliente.timbrar rfc, layout, 'generarCBB' => generar_cbb
  end

  # Public: Envía un archivo al PAC para ser timbrado tanto en formato layout como en formato XML
  #
  # rfc - Es el RFC del emisor
  # archivo - Es el archivo a ser timbrado como un string
  # opciones - Es un hash de opciones que deben coincidir con los parámetros recibidos por Facturación Moderna para el timbrado
  #
  # Regresa un objeto tipo FMRespuesta que contiene el xml certificado, el timbre y la representación en pdf o el cbb en png
  def timbrar (rfc, archivo, opciones= {})
    respuesta = cliente.timbrar rfc, archivo, opciones
  end

  #no implementado todavía
  def cancela_cfdi (uuid)
  end

end
