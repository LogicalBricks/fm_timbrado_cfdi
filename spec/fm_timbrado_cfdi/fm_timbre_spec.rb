# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi::FmTimbre do
  it "debe crear un objeto válido" do
    timbre_as_text = File.open('spec/fixtures/timbre_example.txt').read
    timbre = FmTimbradoCfdi::FmTimbre.new timbre_as_text 
    #Hay elementos que no deben estar vacíos
    timbre.no_certificado_sat.should_not be_nil
    timbre.fecha_timbrado.should_not be_nil
    timbre.uuid.should_not be_nil
    timbre.sello_sat.should_not be_nil
    timbre.sello_cfd.should_not be_nil
  end
end # describe FmTimbre
