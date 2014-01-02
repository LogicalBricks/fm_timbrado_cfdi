# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fm_timbrado_cfdi/version'

Gem::Specification.new do |gem|
  gem.name          = "fm_timbrado_cfdi"
  gem.version       = FmTimbradoCfdi::VERSION
  gem.authors       = ["Carlos García", "Hermes Ojeda Ruiz", "Crisóforo Gaspar Hernández @mitogh"]
  gem.email         = ["hermes.ojeda@logicalbricks.com"]
  gem.homepage      = "https://github.com/LogicalBricks/fm_timbrado_cfdi"
  gem.summary       = %q{Implementación en ruby de la conexión con el servicio de timbrado de cfdi con el PAC Facturación Moderna}
  gem.description   = "Implementación en Ruby de la Conexión con el Servicio de Timbrado de CFDI con el PAC: Facturación Moderna"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "nokogiri"
  gem.add_dependency "savon"

  gem.add_development_dependency "rspec"
end
