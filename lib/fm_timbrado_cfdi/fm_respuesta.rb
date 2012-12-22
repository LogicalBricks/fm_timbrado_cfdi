require 'nokogiri'
require 'savon'

module FmTimbradoCfdi
  class FmRespuesta
      attr_reader :errors, :pdf, :xml, :cbb, :timbre  
      def initialize(savon_response)
        #inicializamos el estado del objeto
        @error = false
        @errors = []
        parse(savon_response)
      end #initialize

      def parse (savon_response)
              begin
                      #vemos si la petción fue correcta
                      if savon_response.success? then
                              @doc = Nokogiri::XML(savon_response.to_xml)
                              #Parseamos el nodo xml
                              if not @doc.xpath("//xml").empty? then
                                      @xml = Base64::decode64 @doc.xpath("//xml")[0].content
                              else
                                      @xml = nil
                                      @error = true
                                      @errors << "No se ha encontrado el nodo xml"
                              end
                              #Parseamos el nodo timbre
                              if not @doc.xpath("//txt").empty? then
                                      @timbre = Base64::decode64 @doc.xpath("//txt")[0].content
                              else
                                      @timbre = nil
                                      @error = true
                                      @errors << "No se ha encontrado el nodo para el timbre fiscal"
                              end
                              #Parseamos el nodo pdf
                              if not @doc.xpath("//pdf").empty? then
                                      @pdf = Base64::decode64 @doc.xpath("//pdf")[0].content
                              else
                                      @pdf = nil
                                      @error = true unless not @doc.xpath("//cbb").empty? 
                                      @errors << "No se ha encontrado el nodo para el timbre fiscal" unless not @doc.xpath("//cbb").empty? 
                              end
                              #Parseamos el nodo cbb
                              if not @doc.xpath("//cbb").empty? then
                                      @cbb = Base64::decode64 @doc.xpath("//cbb")[0].content
                              else
                                      @cbb = nil
                                      @error = true unless not @doc.xpath("//pdf").empty? 
                                      @errors << "No se ha encontrado el nodo para el timbre fiscal" unless not @doc.xpath("//pdf").empty? 
                              end
                      else
                              @error = true
                              @errors << savon_response.soap_fault.to_s if savon_response.soap_fault.present?
                              @pdf = nil
                              @xml = nil
                              @cbb = nil
                              @timbre = nil
                              #@errors << savon_response.http_error.to_s if savon_response.http_error.present?
                      end

              rescue Exception => e
                      @error = true
                      @errors << "No se ha podido realizar el parseo de la respuesta. #{e.message}"
              end
      end #parse

      def valid?
              @error
      end
  end #class
end #module
