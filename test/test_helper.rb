$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'minitest/autorun'
require 'action_dispatch'
require 'ensure_subdomain'
require 'ostruct'

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

def heroku_request
  base = empty_subdomain_request
  base[:subdomain] = base[:domain].sub('.com', '')
  base[:domain] = 'herokuapp.com'
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

def router
  ActionDispatch::Routing::RouteSet.new
end

def www_router
  router.draw do
    ensure_www
  end
  router
end

def empty_router
  router.draw do
    ensure_no_www
  end
  router
end
