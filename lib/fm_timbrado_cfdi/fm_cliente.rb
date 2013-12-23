require 'savon'
require 'fm_timbrado_cfdi/fm_respuesta'

module FmTimbradoCfdi
  class FmCliente
    #attrs
    attr_accessor :user_id, :user_pass, :namespace, :fm_wsdl, :endpoint, :ssl_verify_mode, :log, :log_level

    def initialize
      # La configuracion por default es la del ambiente de pruebas de FM
      # Datos de acceso al webservice
      @user_id = 'UsuarioPruebasWS'
      @user_pass = 'b9ec2afa3361a59af4b4d102d3f704eabdf097d4'
      # Datos del webservide de prueba
      @namespace = "https://t2demo.facturacionmoderna.com/timbrado/soap"
      @endpoint = "https://t2demo.facturacionmoderna.com/timbrado/soap"
      @fm_wsdl = "https://t2demo.facturacionmoderna.com/timbrado/wsdl"

      #Opciones adicionales
      @log = false
      @log_level = :error
      @ssl_verify_mode = :none
    end

    def peticion_timbrar rfc_emisor, documento, generar_cbb
      text_to_cfdi = Base64::encode64( documento )
      # Realizamos la peticion
      configurar_cliente
      response = @client.request "ns1:requestTimbrarCFDI" do
        soap.namespace = @namespace
        soap.body = { "param0" => {
          "UserPass" => user_pass,
          "UserID" => user_id,
          "emisorRFC" => rfc_emisor,
          "text2CFDI" => text_to_cfdi,
          "generarCBB" => generar_cbb
        } }
      end # response
      FmRespuesta.new(response)
    end #peticion timbrar

    private
    def configurar_cliente
      # Configuración de Savon
      Savon.configure do |config|
        config.raise_errors = false
        config.log_level = log_level
        config.log = log
      end

      @client  = Savon::Client.new do
        http.auth.ssl.verify_mode = ssl_verify_mode
        wsdl.document = fm_wsdl
        wsdl.endpoint = endpoint
      end
      HTTPI.log =  log
    end

  end #class
end#module
