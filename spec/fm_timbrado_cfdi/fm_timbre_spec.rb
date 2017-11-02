# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmTimbre do
  context "debe crear un objeto válido" do
    let(:plantilla){File.open('spec/fixtures/layout_example.txt').read}
    let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
    let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
    let(:timbre) { FmTimbradoCfdi::FmTimbre.new(respuesta.xml)}
    it { expect(timbre.no_certificado_sat).to_not be_nil }
    it { expect(timbre.fecha_timbrado).to_not be_nil }
    it { expect(timbre.uuid).to_not be_nil }
    it { expect(timbre.sello_sat).to_not be_nil }
    it { expect(timbre.sello_cfd).to_not be_nil }
    it { expect(timbre.cadena_original).to_not be_nil }
  end
end
