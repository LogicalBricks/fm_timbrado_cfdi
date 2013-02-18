# FmTimbradoCfdi

Implementa la conexión con el servicio de timbrado cfdi con el PAC Facturación Moderna [Guía de Desarrollo de FM](http://developers.facturacionmoderna.com).

## Installation

Add this line to your application's Gemfile:

    gem 'fm_timbrado_cfdi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fm_timbrado_cfdi

## Usage

Para usar la gema es necesario realizar la configuración con los valores de conexión:
      FmTimbradoCfdi.configurar do |config|
        config.user_id = 'user_id' 
        config.user_pass = 'password' 
        config.namespace = 'http://serviciondetimrado...' 
        config.endpoint = 'http://serviciondetimrado...'
        config.fm_wsdl = 'http://serviciondetimrado...'
        config.log = 'path_to_log'
        config.ssl_verify_mode = true 
      end # configurar

Y realizar la petición de timbrado:

response = FmTimbradoCfdi.timbra_cfdi_layout rfc, 'layout_file', true



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Esta gema fue creada por LogicalBricks Solutions.
