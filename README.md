# ensure_subdomain

an ActionDispatch extension to handle subdomain redirects

Let's say you believe that [using the www subdomain is dumb](http://no-www.org).
Ensuring your rails app doesn't use this subdomain is pretty easy, but now it's easier.

    # Gemfile
	gem 'ensure_subdomain'
	
	# Preferred terminal
	`bundle install`
	
	# config/routes.rb
	My::Application.routes.draw do
	    ensure_no_www
		
		# The rest of my cool routes
    end
	
GETting http://www.my-app.dev/ will redirect to http://my-app.dev
Simple as that.

Conversely, if you are wrong and think you should use www, there's a method for that.

    # config/routes.rb
	My::Application.routes.draw do
	    ensure_www
	end

GETting http://www.my-app.dev/ will redirect to http://my-app.dev	


Finally, if you've got some other domain, there's a method for that too.

	# config/routes.rb
	My::Application.routes.draw do
		ensure_subdomain 'blog'
	end
	
GETting http://my-app.dev/ will redirect to http://blog.my-app.dev
