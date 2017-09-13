# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmTimbre3_3 do
  context "debe crear un objeto válido" do
    let(:plantilla){File.open('spec/fixtures/layout_example3_3.txt').read}
    let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
    let(:respuesta){ FmTimbradoCfdi.timbrar3_3 'ESI920427886', layout }
    let(:timbre) { FmTimbradoCfdi::FmTimbre3_3.new(respuesta.xml)}
    it { timbre.no_certificado_sat.should_not be_nil }
    it { timbre.fecha_timbrado.should_not be_nil }
    it { timbre.uuid.should_not be_nil }
    it { timbre.sello_sat.should_not be_nil }
    it { timbre.sello_cfd.should_not be_nil }
    it { timbre.cadena_original.should_not be_nil }
    it { timbre.rfc_provedor_certificado.should_not be_nil }
  end
end
