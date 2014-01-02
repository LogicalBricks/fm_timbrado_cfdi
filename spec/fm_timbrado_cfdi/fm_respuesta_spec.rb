# encoding: utf-8
require 'spec_helper'
require 'ostruct'

describe FmTimbradoCfdi::FmRespuesta do
  context "respuesta no satisfactoria" do
    let(:respuesta_cliente) do
      prueba = OpenStruct.new
      prueba.stub(:success?).and_return(false)
      prueba.stub_chain(:soap_fault?).and_return(true)
      prueba.stub_chain(:soap_fault, :to_s).and_return('Test Error')
      prueba
    end
    let(:respuesta) { FmTimbradoCfdi::FmRespuesta.new(respuesta_cliente) }
    it { expect(respuesta.valid?).to eq(false) }
    it { expect(respuesta.xml?).to eq(false) }
    it { expect(respuesta.pdf?).to eq(false) }
    it { expect(respuesta.cbb?).to eq(false) }
    it { expect(respuesta.timbre?).to eq(false) }
    it { expect(respuesta.no_csd_emisor?).to eq(false) }
  end

  context "respuesta sin xml" do
    let(:texto_respuesta){File.open('spec/fixtures/soap_response_sin_xml.txt').read}
    let(:respuesta) { FmTimbradoCfdi::FmRespuesta.new(texto_respuesta) }
    it { expect(respuesta.valid?).to eq(false) }
  end

end
