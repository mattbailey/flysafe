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
  @corp = API.new('corp')
  @assets = assets_to_list(@corp.AssetList.assets).sort_by { |h| h.class.to_s }
  haml :assets
end
