# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmRespuestaCancelacionParser do
  let(:plantilla) { "" }
  let(:xml) { File.open("spec/fixtures/cancellation_responses/#{plantilla}").read }
  subject(:respuesta) { FmTimbradoCfdi::FmRespuestaCancelacionParser.new(xml) }

  context "con respuesta válida de cancelación directa" do
    let(:plantilla) { "respuesta_valida_directa.xml" }

    it { expect(respuesta.codigo).to eq('GT05') }
    it { expect(respuesta.mensaje).to eq('CFDI Cancelado.') }
  end # context con una respuesta de error

  context "con respuesta válida de cancelación con autorización" do
    let(:plantilla) { "respuesta_valida_con_autorizacion.xml" }

    it { expect(respuesta.codigo).to eq('GT11') }
    it { expect(respuesta.mensaje).to eq('Solicitud de cancelación recibida. El receptor debe autorizar la cancelación.') }
  end # context con respuesta válida de cancelación con autorización
end # describe
