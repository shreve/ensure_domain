require 'minitest/autorun'
require 'action_dispatch'
require File.join(File.dirname(__FILE__), '../lib/ensure_subdomain')
require 'ostruct'

class TestEnsureSubdomain < MiniTest::Unit::TestCase
=begin
	Test that the EnsureSubdomain constraint matching works.
	Involves class initialization, and the matches method
=end
	def test_empty_subdomain_will_redirect_to_www
		redirector = www_redirector
		assert redirector.matches?(empty_subdomain_request),
			"request with empty subdomain won't redirect with www_redirector"
	end

	def test_empty_subdomain_will_not_redirect_if_empty
		redirector = empty_redirector
		refute redirector.matches?(empty_subdomain_request),
			"request with empty subdomain will redirect with empty_redirector"
	end

	def test_www_will_redirect_to_empty
		redirector = empty_redirector
		assert redirector.matches?(subdomain_request),
			"request with www subdomain won't redirect with empty_redirector"
	end

	def test_www_will_not_redirect_if_www
		redirector = www_redirector
		refute redirector.matches?(subdomain_request),
			"request with www subdomain will redirect with www_redirector"
	end

=begin
	Test that the EnsureSubdomain url generator works.
	Involves the to method
=end
	def test_www_redirector_generates_www_url
		redirector = www_redirector
		assert_equal "http://www.example.com", redirector.to(no_path_params, empty_subdomain_request)
	end

	def test_empty_redirector_generates_empty_url
		redirector = empty_redirector
		assert_equal "http://example.com", redirector.to(no_path_params, subdomain_request)
	end

	def test_path_is_included
		redirector = empty_redirector
		assert_equal "http://example.com/user/signup", redirector.to(path_params, empty_subdomain_request)
	end

=begin
	Test helpers because I'm too lazy for a separate file
=end
	def www_redirector
		EnsureSubdomain.new('www')
	end

	def empty_redirector
		EnsureSubdomain.new('')
	end

	def empty_subdomain_request
		OpenStruct.new(protocol: 'http://', domain: 'example.com', subdomain: '')
	end

	def subdomain_request(sub='www')
		base = empty_subdomain_request
		base[:subdomain] = sub
		base
	end

	def no_path_params
		{ _method: :get }
	end

	def path_params
		base = no_path_params
		base[:path] = 'user/signup'
		base
	end
end
