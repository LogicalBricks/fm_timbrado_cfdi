# FmTimbradoCfdi
[![Build Status](https://travis-ci.org/LogicalBricks/fm_timbrado_cfdi.png?branch=master)](https://travis-ci.org/LogicalBricks/fm_timbrado_cfdi)
[![Code Climate](https://codeclimate.com/github/LogicalBricks/fm_timbrado_cfdi.png)](https://codeclimate.com/github/LogicalBricks/fm_timbrado_cfdi)
[![Coverage Status](https://coveralls.io/repos/LogicalBricks/fm_timbrado_cfdi/badge.png)](https://coveralls.io/r/LogicalBricks/fm_timbrado_cfdi)

Implementa la conexión con el servicio de timbrado cfdi con el PAC Facturación Moderna [Guía de Desarrollo de FM](http://developers.facturacionmoderna.com).

No incluye ninguna funcionalidad de sellado.

## Installation

Agrega esto al Gemfile de tu aplicación:

    gem 'fm_timbrado_cfdi'

Y ejecuta:

    $ bundle

o instala de forma independiente:

    $ gem install fm_timbrado_cfdi

## Uso

Para usar la gema es necesario realizar la configuración con los valores de conexión:

```ruby
FmTimbradoCfdi.configurar do |config|
  config.user_id = 'user_id'
  config.user_pass = 'password'
  config.namespace = 'http://serviciondetimrado...'
  config.endpoint = 'http://serviciondetimrado...'
  config.fm_wsdl = 'http://serviciondetimrado...'
  config.log = 'path_to_log'
  config.ssl_verify_mode = true
end # configurar
```

Y realizar la petición de timbrado:

```ruby
respuesta = FmTimbradoCfdi.timbra_cfdi_layout rfc, 'layout_file', false
# => Petición sin generación del CBB
respuesta = FmTimbradoCfdi.timbra_cfdi_layout rfc, 'layout_file', true
# => Petición con generación del CBB
```

Si cuentas con el XML sellado puedes hacer lo siguiente:

```ruby
respuesta = FmTimbradoCfdi.timbra_cfdi_xml 'archivo_xml', false
# => Petición sin generación del CBB
respuesta = FmTimbradoCfdi.timbra_cfdi_xml 'archivo_xml', true
# => Petición con generación del CBB
```

Para un método más general de timbrado que se encuentre más acorde a la documentación de [Facturación Moderna](http://developers.facturacionmoderna.com):

```ruby
respuesta = FmTimbradoCfdi.timbrar rfc_emisor, 'archivo_xml_o_layout', 'generarCBB' => false, 'generarPDF' => true, 'generarTXT' => false
# => Generar la respuesta con formato PDF, pero sin formato CBB ni TXT
```


El archivo de layout y el XML son string.


## Contribuciones

1. 'Forkea' el repositorio
2. Crea una rama con tu funcionalidad (`git checkout -b my-new-feature`)
3. Envía tus cambios (`git commit -am 'Add some feature'`)
4. 'Pushea' a la rama (`git push origin my-new-feature`)
5. Crea un 'Pull request'

Esta gema fue creada por LogicalBricks Solutions.
