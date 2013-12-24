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
    context "timbrado correcto" do
      context 'archivo de prueba simple' do
        let(:plantilla){File.open('spec/fixtures/layout_example.txt').read}
        let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
        let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
        it { respuesta.should be_valid }
        it { respuesta.should be_xml }

        context "formatos cbb" do
          let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout, true}
          it { respuesta.should be_valid }
          it { respuesta.should be_xml }
          it { respuesta.should be_cbb }
        end
     end
    end

    context 'archivo de constructoras' do
      let(:plantilla){File.open('spec/fixtures/constructora_layout_example.txt').read}
      let(:layout){plantilla.gsub('--fecha-comprobante--', 'asignarFecha')}
      let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
      it { respuesta.should be_valid }
      it { respuesta.should be_xml }
    end
  end

  describe ".timbrar" do
    context "timbrado correcto" do
      context 'archivo de prueba simple' do
        let(:plantilla){File.open('spec/fixtures/layout_example.txt').read}
        let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
        let(:respuesta){ FmTimbradoCfdi.timbrar 'ESI920427886', layout }
        it { respuesta.should be_valid }
        it { respuesta.should be_xml }

        context "formatos cbb" do
          let(:respuesta){ FmTimbradoCfdi.timbrar 'ESI920427886', layout, 'generarCBB' => true }
          it { respuesta.should be_valid }
          it { respuesta.should be_xml }
          it { respuesta.should be_cbb }
        end

        context "formato txt" do
          let(:respuesta){ FmTimbradoCfdi.timbrar 'ESI920427886', layout, 'generarTXT' => true }
          it { respuesta.should be_valid }
          it { respuesta.should be_xml }
          it { respuesta.should be_timbre }
        end

      end
    end

    context 'archivo de constructoras' do
      let(:plantilla){File.open('spec/fixtures/constructora_layout_example.txt').read}
      let(:layout){plantilla.gsub('--fecha-comprobante--', 'asignarFecha')}
      let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
      it { respuesta.should be_valid }
      it { respuesta.should be_xml }
    end
  end

  context 'timbrado incorrecto' do
    it "no timbra el comprobante si tiene más de 72 horas de haber sido generado" do
      fecha_comprobante = Time.now - 73*3600
      layout = File.open('spec/fixtures/layout_example.txt').read.gsub('--fecha-comprobante--', fecha_comprobante.strftime("%FT%T"))
      respuesta = FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout
      respuesta.should_not be_valid
    end
  end
end

describe ".configurar" do
  it "cambia los valores de conexión por los proporcionados" do
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

