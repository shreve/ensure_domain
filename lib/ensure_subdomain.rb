class EnsureSubdomain
	attr_accessor :subdomain

	def initialize(subdomain)
		self.subdomain = subdomain.sub(/\.$/, '')
	end

	def matches?(request)
		# ''.match('www') #=> nil, which is is the opposite of what we want
		(self.subdomain.empty? && request.subdomain.present?) ||
			request.subdomain.match(self.subdomain).nil?
	end

	def to(params, request)
		url = request.protocol
		url << "#{self.subdomain}." if self.subdomain.present?
		url << request.domain
		url << "/#{params[:path]}" if params[:path].present?
		url
	end
end

module ActionDispatch::Routing::Mapper::HttpHelpers
	def ensure_no_www
		ensure_subdomain ''
	end
	alias_method :ensure_non_www, :ensure_no_www

	def ensure_www
		ensure_subdomain 'www'
	end

	def ensure_subdomain(subdomain, options={})
		redirector = EnsureSubdomain.new( subdomain )
		verbs = options[:via] || [:get, :post, :put, :patch, :delete]
		constraints( redirector ) do
			match '/*path', to: redirect { |params, request| redirector.to params, request }, via: verbs
		end
	end
end
