# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmRespuestaConsultarEstadoParser do
  let(:plantilla) { "cancelado_con_aceptacion_vencido.xml" }
  let(:xml) { File.open("spec/fixtures/consultar_estado_responses/#{plantilla}").read }
  subject(:respuesta) { FmTimbradoCfdi::FmRespuestaConsultarEstadoParser.new(xml) }

  context "con respuesta válida de estado cancelado, que requiere aprobación y de estado vencido" do
    it { expect(respuesta.http_code).to eq('200') }
    it { expect(respuesta.estado).to eq('Cancelado') }
    it { expect(respuesta.es_cancelable).to eq('Cancelable con aceptación') }
    it { expect(respuesta.estatus_cancelacion).to eq('Plazo vencido') }
  end # context con respuesta válida de estado cancelado, que requiere aprobación y de estado vencido
end
