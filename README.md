# Ensure Subdomain

_an ActionDispatch extension to handle subdomain redirects_

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

GET www.example.com   → 301   example.com

Simple as that.

Conversely, if you are wrong and think you should use www, there's a method for that.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  ensure_www
end
```

GET example.com  → 301  www.example.com


If you've got some other domain, there's a method for that too.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  ensure_subdomain 'blog'
end
```

GET example.com  → 301  blog.example.com

GET www.example.com  → 301  blog.example.com

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

*Before:* GET application.herokuapp.com  → 301  herokuapp.com  → 301  heroku.com

*After:* GET application.herokuapp.com
