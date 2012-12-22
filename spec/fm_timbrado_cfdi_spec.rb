# encoding: utf-8
require 'spec_helper'

describe FmTimbradoCfdi do
  describe "conexión de prueba" do
    it "debe conectarse correcatmente con los valores de prueba" do
      FmTimbradoCfdi.configurar 
    end
  end #describe "conexión de prueba"
end #describe FmTimbradoCfdi 
