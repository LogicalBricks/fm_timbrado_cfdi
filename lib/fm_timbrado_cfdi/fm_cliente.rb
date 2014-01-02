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
      configurar_cliente
      response = @client.call(:request_timbrar_cfdi,
                              message:
                              { "param0" => {
                                "UserPass" => user_pass,
                                "UserID" => user_id,
                                "emisorRFC" => rfc,
                                "text2CFDI" => text_to_cfdi,
                              }.merge(opciones)
                              }
                             )
      FmRespuesta.new(response)
    end

    def subir_certificado(rfc, certificado, llave, password, opciones = {})
      configurar_cliente
      respuesta = @client.call(:activar_cancelacion,
                   message:
                   { "param0" => {
                     "UserPass" => user_pass,
                     "UserID" => user_id,
                     "emisorRFC" => rfc,
                     "archivoCer" => Base64::encode64(certificado),
                     "archivoKey" => Base64::encode64(llave),
                     "clave" => password,
                   }.merge(opciones)
                   })
      FmRespuestaCancelacion.new(respuesta)
    end

    def cancelar(rfc, uuid, opciones = {})
      configurar_cliente
      respuesta = @client.call(:request_cancelar_cfdi,
                   message:
                   { "param0" => {
                     "UserPass" => user_pass,
                     "UserID" => user_id,
                     "emisorRFC" => rfc,
                     "uuid" => uuid,
                   }.merge(opciones)
                   })
      FmRespuestaCancelacion.new(respuesta)
    end


    private
    def configurar_cliente
      @client  = Savon.client(
        ssl_verify_mode: ssl_verify_mode,
        wsdl: fm_wsdl,
        endpoint: endpoint,
        raise_errors: false,
        log_level: log_level,
        log: log
      )
    end

  end
end
