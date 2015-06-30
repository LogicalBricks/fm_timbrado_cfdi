require 'savon'
require 'fm_timbrado_cfdi/fm_respuesta'
require 'fm_timbrado_cfdi/fm_respuesta_cancelacion'

module FmTimbradoCfdi
  class FmCliente
    attr_accessor :user_id, :user_pass, :namespace, :fm_wsdl, :endpoint, :ssl_verify_mode, :log, :log_level

    def initialize
      # La configuracion por default es la del ambiente de pruebas de FM
      # Datos de acceso al webservice
      @user_id = 'UsuarioPruebasWS'
      @user_pass = 'b9ec2afa3361a59af4b4d102d3f704eabdf097d4'
      # Datos del webservise de prueba
      @namespace = "https://t2demo.facturacionmoderna.com/timbrado/soap"
      @endpoint = "https://t2demo.facturacionmoderna.com/timbrado/soap"
      @fm_wsdl = "https://t2demo.facturacionmoderna.com/timbrado/wsdl"

      #Opciones adicionales
      @log = false
      @log_level = :error
      @ssl_verify_mode = :none
    end

    def timbrar(rfc, documento, opciones={})
      text_to_cfdi = Base64::encode64( documento )
      # Realizamos la peticion
      respuesta = webservice_call(:request_timbrar_cfdi, rfc, {"text2CFDI" => text_to_cfdi}.merge(opciones))
      FmRespuesta.new(respuesta)
    end

    def subir_certificado(rfc, certificado, llave, password, opciones = {})
      parametros = { "archivoCer" => Base64::encode64(certificado),
                     "archivoKey" => Base64::encode64(llave),
                     "clave" => password }
      respuesta = webservice_call(:activar_cancelacion, rfc, parametros.merge(opciones))
      FmRespuestaCancelacion.new(respuesta)
    end

    def cancelar(rfc, uuid, opciones = {})
      respuesta = webservice_call(:request_cancelar_cfdi, rfc, {uuid: uuid}.merge(opciones))
      FmRespuestaCancelacion.new(respuesta)
    end


    private

    def webservice_call(accion, rfc, opciones)
      configurar_cliente
      parametros= { "param0" => { "UserPass" => user_pass, "UserID" => user_id, "emisorRFC" => rfc }.merge(opciones) }
      @client.call(accion,
                   message: parametros
                   )
    end

    def configurar_cliente
      @client = Savon.client(
        ssl_verify_mode: ssl_verify_mode,
        wsdl: fm_wsdl,
        endpoint: endpoint,
        raise_errors: false,
        log_level: log_level,
        log: log,
        open_timeout: 15,
        read_timeout: 15
      )
    end

  end
end
