module EnsureDomain
	class WWW
		def self.matches?(request)
			request.host !~ /^www/
		end
	end

	class NoWWW
		def self.matches?(request)
			request.subdomain =~ /^.*$/
		end
	end

	class Custom
		attr_accessor :pattern
		
		def initialize(pattern)
			self.pattern = pattern
		end

		def matches?(request)
			request.subdomain.match(self.pattern).nil?
		end
	end
end

module ActionDispatch::Routing::Mapper::HttpHelpers
	include EnsureDomain

	def ensure_no_www
		constraints( EnsureDomain::NoWWW ) do
			get '/', to: redirect { |params, request| "#{request.protocol}#{request.domain}" }
			match '/*path', to: redirect { |params, request| "#{request.protocol}#{request.domain}/#{params[:path]}" }, via: [:get, :post, :put, :patch, :delete]
		end
	end
	alias_method :ensure_non_www, :ensure_no_www
	
	def ensure_www
		constraints( EnsureDomain::WWW ) do
			get '/', to: redirect { |params, request| "#{request.protocol}www.#{request.domain}" }
			match '/*path', to: redirect { |params, request| "#{request.protocol}www.#{request.domain}/#{params[:path]}" }, via: [:get, :post, :put, :patch, :delete]
		end
	end

	def ensure_subdomain(*args)
		constraints( EnsureDomain::Custom.new( args[0] ) ) do
			get '/', to: redirect { |params, request| "#{request.protocol}#{args[0]}.#{request.domain}" }
			match '/*path', to: redirect { |params, request| "#{request.protocol}#{args[0]}.#{request.domain}/#{params[:path]}" }, via: [:get, :post, :put, :patch, :delete]
		end
	end
end
