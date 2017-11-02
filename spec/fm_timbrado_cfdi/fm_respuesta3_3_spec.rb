# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmRespuesta3_3 do
  context "respuesta no satisfactoria" do
    let(:respuesta_cliente) { double }

    before :each do
      allow(respuesta_cliente).to receive(:success?).and_return false
      allow(respuesta_cliente).to receive(:soap_fault?).and_return true
      allow(respuesta_cliente).to receive_message_chain(:soap_fault, :to_s).and_return 'Test Error'
    end

    let(:respuesta) { FmTimbradoCfdi::FmRespuesta3_3.new(respuesta_cliente) }
    it { expect(respuesta.valid?).to eq(false) }
    it { expect(respuesta.xml?).to eq(false) }
    it { expect(respuesta.pdf?).to eq(false) }
    it { expect(respuesta.cbb?).to eq(false) }
    it { expect(respuesta.timbre?).to eq(false) }
    it { expect(respuesta.no_csd_emisor?).to eq(false) }
  end

  context 'respuesta correcta' do
    let(:texto_respuesta){File.open('spec/fixtures/soap_response3_3.txt').read}
    let(:respuesta) { FmTimbradoCfdi::FmRespuesta3_3.new(texto_respuesta) }
    it { expect(respuesta.valid?).to eq(true) }
  end

  context "respuesta sin xml" do
    let(:texto_respuesta){File.open('spec/fixtures/soap_response_sin_xml.txt').read}
    let(:respuesta) { FmTimbradoCfdi::FmRespuesta3_3.new(texto_respuesta) }
    it { expect(respuesta.valid?).to eq(false) }
    it { expect(respuesta.errors.first).to eq("No se ha encontrado el nodo xml") }
  end
end
