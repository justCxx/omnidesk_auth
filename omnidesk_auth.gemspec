# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omnidesk_auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'omnidesk_auth'
  spec.version       = OmnideskAuth::VERSION
  spec.authors       = ['V.Kolesnikov']
  spec.email         = ['re.vkolesnikov@gmail.com']

  spec.summary       = 'Omnidesk SSO authentication client'
  spec.description   = 'Simple Omnidesk SSO authentication client. See more: https://support.omnidesk.ru/knowledge_base/item/54180'
  spec.homepage      = 'http://github.com/justcxx/omnidesk_auth'
  spec.license       = 'MIT'

  spec.files         = `git ls-files lib LICENSE.txt README.md`.split
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_dependency 'jwt', '~> 1.0'
end
