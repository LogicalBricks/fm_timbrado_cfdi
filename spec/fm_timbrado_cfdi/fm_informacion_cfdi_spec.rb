# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmInformacionCfdi do
  context "debe crear un objeto válido" do
    let(:plantilla){File.open('spec/fixtures/layout_example.txt').read}
    let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
    let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
    let(:informacion) { FmTimbradoCfdi::FmInformacionCfdi.new(respuesta.xml)}
    it { expect(informacion.total).to_not be_nil }
    it { expect(informacion.total).to eq "1943.00"}
    it { expect(informacion.subtotal).to_not be_nil }
    it { expect(informacion.subtotal).to eq "1850.00"}
    it { expect(informacion.descuento).to_not be_nil }
    it { expect(informacion.descuento).to eq "175.00" }
  end
end
