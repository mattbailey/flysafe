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
