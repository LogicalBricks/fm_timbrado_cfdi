# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmTimbre do
  context "debe crear un objeto válido" do
    let(:plantilla){File.open('spec/fixtures/layout_example.txt').read}
    let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
    let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
    let(:timbre) { FmTimbradoCfdi::FmTimbre.new(respuesta.xml)}
    it { timbre.no_certificado_sat.should_not be_nil }
    it { timbre.fecha_timbrado.should_not be_nil }
    it { timbre.uuid.should_not be_nil }
    it { timbre.sello_sat.should_not be_nil }
    it { timbre.sello_cfd.should_not be_nil }
  end
end
