require_relative './action_dispatch/routing/mapper/http_helpers'

class EnsureSubdomain
  attr_accessor :subdomains

  def initialize(subdomains)
    subdomains = [subdomains] unless subdomains.respond_to?(:map)
    self.subdomains = subdomains.map { |s| s.sub(/\.$/, '') }
  end

  def matches?(request)
    # Don't deal with addresses like http://0.0.0.0:3000
    request.domain.present? and requires_redirect?(request)
  end

  # Only called when not on an appropriate domain
  def to(params, request)
    url = request.protocol
    url << redirect_to_full_domain(request)
    url << "/#{params[:path]}" if params[:path].present?
    url
  end

  private
  def redirect_to_full_domain(request)
    parts = []
    parts << self.subdomains.first if self.subdomains.any?
    parts << request.subdomain if vendor_url?(request)
    parts << request.domain
    parts.reject(&:empty?).join('.')
  end

  def requires_redirect?(request)
    shouldnt_have_a_subdomain?(request) or !on_allowed_subdomain?(request)
  end

  def shouldnt_have_a_subdomain?(request)
    # ''.match('www') #=> nil, which is is the opposite of what we want
    apex_required? and request.subdomain.present?
  end

  def on_allowed_subdomain?(request)
    self.subdomains.select do |subdomain|
      request.subdomain == subdomain
    end.size > 0
  end

  def apex_required?
    self.subdomains.size == 1 && self.subdomains.first == ''
  end

  def vendor_url?(request)
    request.domain.match /heroku/
  end
end
