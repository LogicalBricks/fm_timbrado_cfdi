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
      return nil unless valores.size == 9
      hash = Hash[atributos.zip(valores)]
      hash.each do |variable, valor|
        instance_variable_set("@#{variable}", obtener_valor(valor))
      end
    end

    private

    def obtener_valor(cadena)
      valores = cadena.chomp.split('|')
      valores.size > 1 ? valores[1] : nil
    end

    def atributos
      [ 'trans_id',
        'no_certificado_sat',
        'fecha_timbrado',
        'uuid',
        'sello_sat',
        'sello_cfd',
        'fecha_comprobante',
        'serie',
        'folio' ]
    end

  end
end

