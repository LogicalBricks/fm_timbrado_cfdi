# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmInformacionCfdi do
  context "debe crear un objeto válido" do
    let(:plantilla){File.open('spec/fixtures/layout_example.txt').read}
    let(:layout){ plantilla.gsub('--fecha-comprobante--', 'asignarFecha' )}
    let(:respuesta){ FmTimbradoCfdi.timbra_cfdi_layout 'ESI920427886', layout }
    let(:informacion) { FmTimbradoCfdi::FmInformacionCfdi.new(respuesta.xml)}
    it { informacion.total.should_not be_nil }
    it { informacion.total.should == "116.00"}
    it { informacion.subtotal.should_not be_nil }
    it { informacion.subtotal.should == "100.00"}
    it { informacion.descuento.should_not be_nil }
    it { informacion.descuento.should == "0.00" }
  end
end
