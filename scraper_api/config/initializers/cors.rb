# @file config/initializers/cors.rb
# @description Configures CORS (Cross-Origin Resource Sharing) to allow requests from the frontend running on Vite (localhost:5173).
# @version 1.0.0 - Initial implementation to support frontend-backend communication during development.
# @dependencies Rack::Cors gem
# @usage Placed in config/initializers to load during app initialization.
# @notes Update 'origins' to match the deployed frontend URL in production.
# @authors
#  - Athika Jishida

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' # Your Vite dev server URL
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end