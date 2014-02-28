# -*- encoding: utf-8 -*-

require File.expand_path('../lib/ensure_subdomain/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'ensure_subdomain'
  s.version = EnsureSubdomain::VERSION::STRING
  s.platform = Gem::Platform::RUBY
  s.authors = "Jacob Evan Shreve"
  s.email = %w(jacob@shreve.ly)
  s.summary = 'Ensure requests are going to the right subdomain.'
  s.description = 'Ensure requests are going to the right subdomain to avoid competing with yourself for dem SERPs. Adds a couple methods to ActionDispatch for routes.'
  s.homepage = 'https://github.com/shreve/ensure_subdomain'
  s.license = 'MIT'

  s.add_runtime_dependency 'actionpack', '>= 4.0.0'

  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
