module ActionDispatch::Routing::Mapper::HttpHelpers
  def ensure_no_www
    ensure_subdomain ''
  end
  alias_method :ensure_non_www, :ensure_no_www
  alias_method :ensure_apex, :ensure_no_www

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
    redirector = ::EnsureSubdomain.new( subdomain )
    verbs = options[:via] || [:get, :post, :put, :patch, :delete]
    constraints( redirector ) do
      match '/', to: redirect { |params, request| redirector.to params, request }, via: verbs
      match '/*path', to: redirect { |params, request| redirector.to params, request }, via: verbs
    end
  end
  alias_method :ensure_subdomains, :ensure_subdomain
end

