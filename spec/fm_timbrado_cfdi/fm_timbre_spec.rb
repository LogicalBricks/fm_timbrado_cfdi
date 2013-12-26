# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmTimbre do
  context "debe crear un objeto válido" do
    let(:timbre_as_text) { File.open('spec/fixtures/timbre_example.txt').read }
    let(:timbre) { FmTimbradoCfdi::FmTimbre.new timbre_as_text }
    it { timbre.no_certificado_sat.should_not be_nil }
    it { timbre.fecha_timbrado.should_not be_nil }
    it { timbre.uuid.should_not be_nil }
    it { timbre.sello_sat.should_not be_nil }
    it { timbre.sello_cfd.should_not be_nil }
  end
end
