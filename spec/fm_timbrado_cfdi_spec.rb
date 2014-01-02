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
  end


  describe ".timbra_cfdi_layout" do
    context "timbrado correcto" do
      context 'archivo de prueba simple' do
        let(:plantilla){File.open('spec/fixtures/layout_example.txt').read}
        let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
        let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
        it { respuesta.should be_valid }
        it { respuesta.should be_xml }

        context "formato cbb" do
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

        context "formato cbb" do
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

        context "formato pdf" do
          let(:respuesta){ FmTimbradoCfdi.timbrar 'ESI920427886', layout, 'generarPDF' => true }
          it { respuesta.should be_valid }
          it { respuesta.should be_xml }
          it { respuesta.should be_pdf }
        end

        context "formato pdf, pero no cbb, ni txt" do
          let(:respuesta){ FmTimbradoCfdi.timbrar 'ESI920427886', layout, 'generarPDF' => true, 'generarCBB' => false, 'generarTXT' => false }
          it { respuesta.should be_valid }
          it { respuesta.should be_xml }
          it { respuesta.should be_pdf }
          it { respuesta.should_not be_cbb }
        end
      end
    end

    context 'archivo de constructoras' do
      let(:plantilla){File.open('spec/fixtures/constructora_layout_example.txt').read}
      let(:layout){plantilla.gsub('--fecha-comprobante--', 'asignarFecha')}
      let(:respuesta){ FmTimbradoCfdi.timbrar 'ESI920427886', layout }
      it { respuesta.should be_valid }
      it { respuesta.should be_xml }
    end
  end

  context 'timbrado incorrecto' do
    it "no timbra el comprobante si tiene más de 72 horas de haber sido generado" do
      fecha_comprobante = Time.now - 120*3600
      layout = File.open('spec/fixtures/layout_example.txt').read.gsub('--fecha-comprobante--', fecha_comprobante.strftime("%FT%T"))
      respuesta = FmTimbradoCfdi.timbrar 'ESI920427886', layout
      respuesta.should_not be_valid
    end
  end

  context 'subir certificados' do
    let(:archivo_certificado) { File.read('spec/fixtures/certificados/20001000000200000192.cer') }
    let(:archivo_llave) { File.read('spec/fixtures/certificados/20001000000200000192.key') }
    let(:password) { '12345678a' }
    describe '.activar_cancelacion' do
      context 'petición válida' do
        let(:respuesta){ FmTimbradoCfdi.activar_cancelacion('ESI920427886', archivo_certificado, archivo_llave, password) }
        it{ expect(respuesta.valid?).to eq(true) }
      end

      context 'petición inválida' do
        let(:respuesta){ FmTimbradoCfdi.activar_cancelacion('ESI920427886', archivo_llave, archivo_certificado, password) }
        it{ expect(respuesta.valid?).to eq(false) }
      end
    end

    describe '.subir_certificado' do
      context 'petición válida' do
        let(:respuesta){ FmTimbradoCfdi.subir_certificado('ESI920427886', archivo_certificado, archivo_llave, password) }
        it{ expect(respuesta.valid?).to eq(true) }
      end

      context 'petición inválida' do
        let(:respuesta){ FmTimbradoCfdi.subir_certificado('ESI920427886', archivo_llave, archivo_certificado, password) }
        it{ expect(respuesta.valid?).to eq(false) }
      end
    end

  end

  describe ".cancelar" do
    context "petición inválida" do
      let(:respuesta){ FmTimbradoCfdi.cancelar('ESI920427886', 'asdasasdsa') }
      it{ expect(respuesta.valid?).to eq(false) }
    end

    context "formato válido" do
      let(:respuesta){ FmTimbradoCfdi.cancelar('ESI920427886', '00000000-0000-0000-0000-00000000000000') }
      it{ expect(respuesta.valid?).to eq(false) }
    end

    context "peticion válida" do
      let(:uuid) do
        plantilla = File.open('spec/fixtures/layout_example.txt').read
        layout = plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )
        respuesta = FmTimbradoCfdi.timbrar 'ESI920427886', layout
        respuesta.timbre.uuid
      end
      let(:respuesta){ FmTimbradoCfdi.cancelar('ESI920427886', uuid) }
      it{ expect(respuesta.valid?).to eq(true) }
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
    end
  end

end


