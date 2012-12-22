require 'savon'

module FmTimbradoCfdi
  class Cliente
    #attrs
    attr_accessor :user_id, :user_pass, :namespace
    attr_reader   :config_log, :config_log_level, :ssl_verify_mode, :endpoint, :wsdl


    def endpoint=(value)
      @client.wsdl.endpoint = value
    end

    def wsdl=(value)
      @client.wsdl.document = value
    end

    def ssl_verify_mode=(value)
      @client.http.auth.ssl.verify_mode = value
    end

    def config_log=(value)
      Savon.configure { |config| config.log = value}
    end

    def config_log_level=(value)
      Savon.configure { |config| config.log_level = value}
    end
    #--
    def initialize
      # La configuracion por default es la del ambiente de pruebas de FM 
      @user_id = 'UsuarioPruebasWS'
      @user_pass = 'b9ec2afa3361a59af4b4d102d3f704eabdf097d4'

      @namespace = "https://t2demo.facturacionmoderna.com/timbrado/soap"
      @endpoint = "https://t1demo.facturacionmoderna.com/timbrado/soap"
      @wsdl = "https://t1demo.facturacionmoderna.com/timbrado/wsdl"

      @config_log = false
      @config_log_level = :error
      @httpi_log = false


      # Configuración de Savon
      Savon.configure do |config|
        config.raise_errors = true
        config.log_level = @config_log_level
        config.log = @config_log 
      end

      @client  = Savon::Client.new do
        http.auth.ssl.verify_mode = @ssl_verify_mode
        wsdl.document = @wsdl
        wsdl.endpoint = @endpoint
      end
      HTTPI.log =  @httpi_log

    end

    def peticion_timbrar rfc_emisor, documento, generar_cbb
      text_to_cfdi = Base64::encode64( documento )
      # Realizamos la peticion
      response = @client.request "ns1:requestTimbrarCFDI" do
        soap.namespace = @namespace
        soap.body = { "param0" => {
          "text2CFDI" => text_to_cfdi,
          "UserPass" => @user_pass,
          "UserID" => @user_id, 
          "emisorRFC" => rfc_emisor,
          "generarCBB" => generar_cbb
        } }
      end # response
      respuesta = Nokogiri::XML(response.to_xml)
    end #peticion timbrar

  end #class
end#module
