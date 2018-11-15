# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi do
  describe '.cliente' do
    let(:user_id) { 'UsuarioPruebasWS' }
    let(:user_pass) { 'b9ec2afa3361a59af4b4d102d3f704eabdf097d4' }
    let(:namespace) { 'https://t2demo.facturacionmoderna.com/timbrado/soap' }
    let(:endpoint) { 'https://t2demo.facturacionmoderna.com/timbrado/soap' }
    let(:fm_wsdl) { 'https://t2demo.facturacionmoderna.com/timbrado/wsdl' }

    it 'Por default carga la configuración del ambiente de pruebas' do
      expect(FmTimbradoCfdi.cliente.user_id).to eq user_id
      expect(FmTimbradoCfdi.cliente.user_pass).to eq user_pass
      expect(FmTimbradoCfdi.cliente.namespace).to eq namespace
      expect(FmTimbradoCfdi.cliente.endpoint).to eq endpoint
      expect(FmTimbradoCfdi.cliente.fm_wsdl).to eq fm_wsdl
    end
  end

  describe '.timbra_cfdi_layout' do
    context 'timbrado correcto' do
      context 'archivo de prueba simple' do
        let(:plantilla) { File.open('spec/fixtures/layout_example.txt').read }
        let(:layout) { plantilla.gsub('--fecha-comprobante--', 'asignarFecha') }
        let(:respuesta) do
          FmTimbradoCfdi.timbra_cfdi_layout 'LAN7008173R5', layout
        end
        it { expect(respuesta).to be_valid }
        it { expect(respuesta).to be_xml }

        context 'formato cbb' do
          let(:respuesta) do
            FmTimbradoCfdi.timbra_cfdi_layout 'TUMG620310R95', layout, true
          end
          it { expect(respuesta).to be_valid }
          it { expect(respuesta).to be_xml }
          it { expect(respuesta).to be_cbb }
        end
      end
    end

    context 'archivo de constructoras' do
      let(:plantilla) do
        File.open('spec/fixtures/constructora_layout_example.txt').read
      end
      let(:layout) { plantilla.gsub('--fecha-comprobante--', 'asignarFecha') }
      let(:respuesta) { FmTimbradoCfdi.timbra_cfdi_layout 'LAN7008173R5', layout }
      it { expect(respuesta).to be_valid }
      it { expect(respuesta).to be_xml }
    end
  end

  describe '.timbrar' do
    context 'timbrado correcto' do
      context 'archivo de prueba simple' do
        let(:plantilla) { File.open('spec/fixtures/layout_example.txt').read }
        let(:layout) { plantilla.gsub('--fecha-comprobante--', 'asignarFecha') }
        let(:respuesta) { FmTimbradoCfdi.timbrar 'LAN7008173R5', layout }
        it { expect(respuesta).to be_valid }
        it { expect(respuesta).to be_xml }

        context 'formato cbb' do
          let(:respuesta) do
            FmTimbradoCfdi.timbrar 'LAN7008173R5', layout, 'generarCBB' => true
          end
          it { expect(respuesta).to be_valid }
          it { expect(respuesta).to be_xml }
          it { expect(respuesta).to be_cbb }
        end

        context 'formato txt' do
          let(:respuesta) do
            FmTimbradoCfdi.timbrar 'LAN7008173R5', layout, 'generarTXT' => true
          end
          it { expect(respuesta).to be_valid }
          it { expect(respuesta).to be_xml }
          it { expect(respuesta).to be_timbre }
        end

        context 'formato pdf' do
          let(:respuesta) do
            FmTimbradoCfdi.timbrar 'LAN7008173R5', layout, 'generarPDF' => true
          end
          it { expect(respuesta).to be_valid }
          it { expect(respuesta).to be_xml }
          it { expect(respuesta).to be_pdf }
        end

        context 'formato pdf, pero no cbb, ni txt' do
          let(:respuesta) do
            FmTimbradoCfdi.timbrar('LAN7008173R5', layout,
                                   'generarPDF' => true, 'generarCBB' => false,
                                   'generarTXT' => false)
          end
          it { expect(respuesta).to be_valid }
          it { expect(respuesta).to be_xml }
          it { expect(respuesta).to be_pdf }
          it { expect(respuesta).to_not be_cbb }
        end
      end
    end

    context 'archivo de constructoras' do
      let(:plantilla) { File.open('spec/fixtures/constructora_layout_example.txt').read }
      let(:layout) { plantilla.gsub('--fecha-comprobante--', 'asignarFecha') }
      let(:respuesta) { FmTimbradoCfdi.timbrar 'LAN7008173R5', layout }
      it { expect(respuesta).to be_valid }
      it { expect(respuesta).to be_xml }
    end
  end

  context 'timbrado incorrecto' do
    context 'cuando comprobante tiene más de 72 horas de haber sido generado' do
      it 'no lo timbra' do
        fecha_comprobante = Time.now - 120 * 3600
        layout = File.open('spec/fixtures/layout_example.txt').read
                     .gsub('--fecha-comprobante--', fecha_comprobante.strftime('%FT%T'))
        respuesta = FmTimbradoCfdi.timbrar 'LAN7008173R5', layout
        expect(respuesta).to_not be_valid
      end
    end
  end

  context 'subir certificados' do
    let(:archivo_certificado) do
      File.read('spec/fixtures/certificados/20001000000200000192.cer')
    end
    let(:archivo_llave) do
      File.read('spec/fixtures/certificados/20001000000200000192.key')
    end
    let(:password) { '12345678a' }
    describe '.activar_cancelacion' do
      context 'petición válida' do
        let(:respuesta) do
          FmTimbradoCfdi.activar_cancelacion('LAN7008173R5',
                                             archivo_certificado,
                                             archivo_llave,
                                             password)
        end
        it{ expect(respuesta.valid?).to eq(true) }
      end

      context 'petición inválida' do
        let(:respuesta) do
          FmTimbradoCfdi.activar_cancelacion('LAN7008173R5',
                                             archivo_llave,
                                             archivo_certificado,
                                             password)
        end
        it{ expect(respuesta.valid?).to eq(false) }
      end
    end

    describe '.subir_certificado' do
      context 'petición válida' do
        let(:respuesta) do
          FmTimbradoCfdi.subir_certificado('LAN7008173R5',
                                           archivo_certificado,
                                           archivo_llave,
                                           password)
        end
        it{ expect(respuesta.valid?).to eq(true) }
      end

      context 'petición inválida' do
        let(:respuesta) do
          FmTimbradoCfdi.subir_certificado('LAN7008173R5',
                                           archivo_llave,
                                           archivo_certificado,
                                           password)
        end
        it{ expect(respuesta.valid?).to eq(false) }
      end
    end
  end

  describe '.cancelar' do
    context 'petición inválida' do
      let(:respuesta){ FmTimbradoCfdi.cancelar('LAN7008173R5', 'asdasasdsa') }
      it{ expect(respuesta.valid?).to eq(false) }
    end

    context 'formato válido' do
      let(:respuesta) do
        FmTimbradoCfdi.cancelar('LAN7008173R5',
                                '00000000-0000-0000-0000-00000000000000')
      end

      it{ expect(respuesta.valid?).to eq(false) }
      it{ expect(respuesta.codigo_error).not_to be_nil }
      it{ expect(respuesta.mensaje_error).not_to be_nil }
    end

    context 'cancelar un comprobante válido' do
      let(:respuesta){ 
        plantilla = File.open('spec/fixtures/layout_example.txt').read
        layout = plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )
        respuesta = FmTimbradoCfdi.timbrar 'LAN7008173R5', layout
        respuesta_c = FmTimbradoCfdi.cancelar('LAN7008173R5', respuesta.timbre.uuid)
        respuesta_c
      }

      it "regresa una respuesta válida con un código y mensaje" do
        expect(respuesta.valid?).to eq(true)
        expect(respuesta.codigo).to eq 'GT05'
        expect(respuesta.mensaje).to eq 'Solicitud de cancelación recibida.'
      end
    end
  end

  describe ".consultar_estado" do
    context "para un comprobante existente" do
      context "comprobante menor a 5000 no cancelado" do
        let(:uuid) do
          plantilla = File.open('spec/fixtures/layout_example.txt').read
          layout = plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )
          respuesta = FmTimbradoCfdi.timbrar 'LAN7008173R5', layout
          respuesta.timbre.uuid
        end

        let(:rfc_receptor) { "AAQM610917QJA" }
        let(:monto) { 1943.00 }

        it "regresa el estado de no encontrado" do
          respuesta = FmTimbradoCfdi.consultar_estado('LAN7008173R5', rfc_receptor, monto, uuid)
          expect(respuesta.http_code).to eq("404")
          expect(respuesta.estado).to eq("No Encontrado")
        end
      end # context comprobante menor a 5000
    end # context para un comprobante existente

    context "para un uuid inexistente" do
      let(:uuid) { '00000000-0000-0000-0000-00000000000000' }
      let(:rfc_receptor) { "AAQM610917QJA" }
      let(:monto) { 19430.00 }

      it "regresa el estado como cancelado" do
        respuesta = FmTimbradoCfdi.consultar_estado('LAN7008173R5', rfc_receptor, monto, uuid)
        expect(respuesta.codigo_error).not_to be_nil
        expect(respuesta.mensaje_error).not_to be_nil
      end
    end # context para un uuid inexistente
  end # describe consultar_estado

  describe '.configurar' do
    it 'cambia los valores de conexión por los proporcionados' do
      FmTimbradoCfdi.configurar do |config|
        config.user_id = 'mi_usuario'
        config.user_pass = 'secret'
        config.namespace = 'http://logicalbricks.com/soap'
        config.endpoint = 'http://logicalbricks.com/endpoint'
        config.fm_wsdl = 'http://logicalbricks.com/wsdl'
      end

      expect(FmTimbradoCfdi.cliente.user_id).to eq 'mi_usuario'
      expect(FmTimbradoCfdi.cliente.user_pass).to eq 'secret'
      expect(FmTimbradoCfdi.cliente.namespace).to eq 'http://logicalbricks.com/soap'
      expect(FmTimbradoCfdi.cliente.endpoint).to eq 'http://logicalbricks.com/endpoint'
      expect(FmTimbradoCfdi.cliente.fm_wsdl).to eq 'http://logicalbricks.com/wsdl'
    end
  end
end
