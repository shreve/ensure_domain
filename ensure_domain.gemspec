# -*- encoding: utf-8 -*-

require File.expand_path('../lib/ensure_domain/version', __FILE__)

Gem::Specification.new do |s|
	s.name = 'ensure_domain'
	s.version = EnsureDomain::VERSION
	s.platform = Gem::Platform::RUBY
	s.authors = %w(Jacob Evan Shreve)
	s.email = %w(jacob@shreve.ly)
	s.summary = 'Ensure requests are going to the right domain.'
	s.description = 'Ensure requests are going to the right subdomain to avoid competing with yourself for dem SERPs. Adds a couple methods to ActionDispatch for routes.'

	s.add_dependency 'actionpack', '~>4.0.0'

	s.files = `git ls-files`.split("\n")
	s.require_path = 'lib'
end
