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
      @trans_id = obtener_valor(valores[0])

      # noCertificadoSAT
      @no_certificado_sat = obtener_valor(valores[1])

      # FechaTimbrado
      @fecha_timbrado = obtener_valor(valores[2])

      # uuid
      @uuid = obtener_valor(valores[3])

      # selloSAT
      @sello_sat = obtener_valor(valores[4])

      # selloCFD
      @sello_cfd = obtener_valor(valores[5])

      # Fecha
      @fecha_comprobante = obtener_valor(valores[6])

      # Serie
      @serie = obtener_valor(valores[7])

      # folio
      @folio = obtener_valor(valores[8])
    end

    private
      def obtener_valor(cadena)
        valores = cadena.chomp.split('|')
        valores.size > 1 ? valores[1] : nil
      end

  end
end

