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
    url << "#{request.subdomain}." if vendor_url?(request)
    url << request.domain
    url << "/#{params[:path]}" if params[:path].present?
    url
  end

  private
  def vendor_url?(request)
    request.domain.match /heroku/
  end
end

module ActionDispatch::Routing::Mapper::HttpHelpers
  def ensure_no_www
    ensure_subdomain ''
  end
  alias_method :ensure_non_www, :ensure_no_www, :ensure_apex

  def ensure_www
    ensure_subdomain 'www'
  end

  def ensure_on(environments)
    environments.each_pair do |env, domain|
      if Rails.env.to_sym == env
        ensure_subdomain domain
      end
    end
  end

  def ensure_subdomain(subdomain, options={})
    redirector = EnsureSubdomain.new( subdomain )
    verbs = options[:via] || [:get, :post, :put, :patch, :delete]
    constraints( redirector ) do
      match '/', to: redirect { |params, request| redirector.to params, request }, via: verbs
      match '/*path', to: redirect { |params, request| redirector.to params, request }, via: verbs
    end
  end
end
