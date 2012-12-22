# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi do
  describe ".cliente" do
    it "Por default el cliente debe cargar la configuración del ambiente de pruebas" do
      FmTimbradoCfdi.cliente.user_id.should == 'UsuarioPruebasWS'
      FmTimbradoCfdi.cliente.user_pass.should == 'b9ec2afa3361a59af4b4d102d3f704eabdf097d4'
      FmTimbradoCfdi.cliente.namespace.should == 'https://t2demo.facturacionmoderna.com/timbrado/soap'
      FmTimbradoCfdi.cliente.endpoint.should == 'https://t2demo.facturacionmoderna.com/timbrado/soap'
      FmTimbradoCfdi.cliente.fm_wsdl.should == 'https://t2demo.facturacionmoderna.com/timbrado/wsdl'
    end
  end #describe .cliente"


  describe ".timbra_cfdi_layout" do
    it "debe timbrar correctamente el archivo de prueba" do
      FmTimbradoCfdi.configurar do |cliente|
        cliente.log = false 
      end

      fecha_comprobante = Time.now - 76*3600
      layout = File.open('spec/fixtures/layout_example.txt').read.gsub('--fecha-comprobante--', fecha_comprobante.strftime("%FT%T"))
      respuesta = FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout
      puts respuesta 
    end # it "debe timbrar correctamente ..."
  end #describe ".timbra_cfdi_layout"

  describe ".configurar" do
    it "debe cambiar los valores de conexión por los proporcionados" do
      FmTimbradoCfdi.configurar do |config|
        config.user_id = "mi_usuario"
        config.user_pass = "secret"
        config.namespace = "http://logicalbricks.com/soap"
        config.endpoint = "http://logicalbricks.com/endpoint"
        config.fm_wsdl = "http://logicalbricks.com/wsdl"
      end 

      FmTimbradoCfdi.cliente.user_id.should == 'mi_usuario'
      FmTimbradoCfdi.cliente.user_pass.should == 'secret'
      FmTimbradoCfdi.cliente.namespace.should == 'http://logicalbricks.com/soap'
      FmTimbradoCfdi.cliente.endpoint.should == 'http://logicalbricks.com/endpoint'
      FmTimbradoCfdi.cliente.fm_wsdl.should == 'http://logicalbricks.com/wsdl'
    end # describe it "debe cambiar los valores ..."
  end #describe .configurar

end #describe FmTimbradoCfdi 
