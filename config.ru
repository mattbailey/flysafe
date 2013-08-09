require './main'

enable :logging
set :views, ['views/layouts', 'views/pages', 'views/partials']
register Sinatra::Flash

if Sinatra::Base.environment == :production
  app = Rack::Auth::Digest::MD5.new(Sinatra::Application) do |username|
    {$redis.hget("#{NAMESPACE}:config", user) => $redis.hget("#{NAMESPACE}:config", password)}[username]
  end
  app.realm = 'Protected Area'
  app.opaque = '400d4427843bf2cdd848eefc41f9da3da6e1e4fe05e126a90abf4da195b593f4e4362e6810fb39982c4f74ae'
  run app
else
  run Sinatra::Application
end
