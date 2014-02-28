# Ensure Subdomain

an ActionDispatch extension to handle subdomain redirects

Let's say you believe that [using the www subdomain is dumb](http://no-www.org).
Ensuring your rails app doesn't use this subdomain is pretty easy, but now it's easier.

```ruby
# Gemfile
gem 'ensure_subdomain'

# Preferred terminal
`bundle install`

# config/routes.rb
Rails.application.routes.draw do
  ensure_apex # or ensure_no_www or ensure_non_www

  # The rest of my cool routes
end
```

GET http://www.example.com  -> 301  http://example.com
Simple as that.

Conversely, if you are wrong and think you should use www, there's a method for that.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  ensure_www
end
```

GET http://example.com  -> 301  http://www.example.com


If you've got some other domain, there's a method for that too.

```ruby
# config/routes.rb
My::Application.routes.draw do
  ensure_subdomain 'blog'
end
```

GET http://example.com  -> 301  http://blog.example.com
GET http://www.example.com  -> 301  http://blog.example.com

What if you want to control the direction for different environments? I've got ya.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  ensure_on production: 'www',
    staging: 'staging',
    development: 'dev'
end
```

Also recently added, and somewhat experimental, _not fucking up on Heroku!_

*Before:* GET http://application.herokuapp.com  -> 301  http://herokuapp.com  -> 301  http://heroku.com
*After:* GET http://application.herokuapp.com
