# -*- encoding : utf-8 -*-
require 'nokogiri'

module FmTimbradoCfdi
  class FmTimbre
    attr_reader :no_certificado_sat, :fecha_timbrado, :uuid, :sello_sat, :sello_cfd, :fecha_comprobante, :serie, :folio, :trans_id

    def initialize ( nodo_timbre )
      parse( nodo_timbre ) 
    end # initialize
    
    def parse ( nodo_timbre )
      valores = nodo_timbre.split("\n")
      return unless valores.size == 9

      # TransID
      temp_value = valores[0].chomp.split('|')
      @trans_id = temp_value[1] if temp_value.size > 1

      # noCertificadoSAT
      temp_value = valores[1].chomp.split('|')
      @no_certificado_sat = temp_value[1] if temp_value.size > 1

      # FechaTimbrado
      temp_value = valores[2].chomp.split('|')
      @fecha_timbrado = temp_value[1] if temp_value.size > 1

      # uuid
      temp_value = valores[3].chomp.split('|')
      @uuid = temp_value[1] if temp_value.size > 1

      # selloSAT
      temp_value = valores[4].chomp.split('|')
      @sello_sat = temp_value[1] if temp_value.size > 1

      # selloCFD 
      temp_value = valores[5].chomp.split('|')
      @sello_cfd = temp_value[1] if temp_value.size > 1

      # Fecha
      temp_value = valores[6].chomp.split('|')
      @fecha_comprobante = temp_value[1] if temp_value.size > 1

      # Serie
      temp_value = valores[7].chomp.split('|')
      @serie = temp_value[1] if temp_value.size > 1

      # folio
      temp_value = valores[8].chomp.split('|')
      @folio = temp_value[1] if temp_value.size > 1
    end # parse

  end # class
end # module

