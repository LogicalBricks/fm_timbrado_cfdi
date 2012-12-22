require 'nokogiri'

module FmTimbradoCfdi
  class FmRespuesta
      def initialize(xml_response)
        #inicializamos el estado del objeto
        @error = false
        @errors = []
        parse(xml_response)
      end #initialize

      def parse (xml)
        begin 
          @doc = Nokogiri::XML(xml)
          
        rescue Exception => e
          @error = true
          @errors < "No se ha podido realizar el parseo de la respuesta. #{e.message}"
        end
      end #parse

    end
  end #class
end #module
