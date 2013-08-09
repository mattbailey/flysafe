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
  @tmpkey = "#{NAMESPACE}:temp:#{(0...8).map{(65+rand(26)).chr}.join}"
  @assets = assets_to_list(@corp.AssetList.assets, @tmpkey).sort_by { |h| h.class.to_s }
  $redis.del @tmpkey
  haml :assets
end
