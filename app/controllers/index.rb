include Flysafe

get "/" do
  @api = API.new('server')
  if @api.ServerStatus.serverOpen
    @status = 'online'
  else
    @status = 'offline'
  end
  @players = @api.ServerStatus.onlinePlayers
  haml :index
end

get "/assets" do
  corp = API.new('corp')
  @assets = corp.AssetList.assets
  haml :assets
end

get "/map" do
  @maps = $redis.keys("#{NAMESPACE}:map:*")
  haml :maps
end

post "/map" do
  @mapid = Digest::SHA1.hexdigest(params[:name])
  if $redis.keys(@mapid)
    @exists = true
  else
    @exists = false
    @newmap = {
      :name    => params[:name],
      :creator => env['HTTP_EVE_CHARNAME'],
      :start   => env['HTTP_EVE_SOLARSYSTEMNAME'],
    }
    h2r("#{NAMESPACE}:map:#{@mapid}", @newmap)
  end
  redirect "/map/#{@mapid}"
  haml :map
end

post "/map/update" do
  @headers = headers
  haml :map
end
