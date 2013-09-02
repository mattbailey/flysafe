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
  @mapkeys = $redis.keys("#{NAMESPACE}:map:*")
  @maps ||= {}
  @mapkeys.each do |key|
    time = key.split(':').last.to_i
    @maps[time] = $redis.hgetall(key).symbolize_keys
  end
  haml :maps
end

post "/map" do
  @time = params[:time]
  if $redis.keys("#{NAMESPACE}:map:#{@time}") != []
    @exists = false
  else
    @exists = true
    @newmap = {
      :time     => @time,
      :creator  => env['HTTP_EVE_CHARNAME'],
      :start    => env['HTTP_EVE_SOLARSYSTEMNAME'],
      :startid  => env['HTTP_EVE_SOLARSYSTEMID'],
      :startsec => system_meta(env['HTTP_EVE_SOLARSYSTEMID'])[:security].to_f,
      :ship     => env['HTTP_EVE_SHIPTYPENAME'],
      :corp     => env['HTTP_EVE_CORPNAME']
    }
    h2r("#{NAMESPACE}:map:#{@time}", @newmap)
  end
  redirect "/edit/map/#{@time}"
end

get "/edit/:class/:id" do
  @id = params[:id]
  @class = params[:class]
  @template = "edit_#{@class}".to_sym
  haml @template
end

get "/view/:class/:id" do
  @id = params[:id]
  @class = params[:class]
  @template = "view_#{@class}".to_sym
  haml @template
end

get "/delete/:class/:id" do
  @id = params[:id]
  @class = params[:class]
  delete_item(@class, @id)
  redirect "/#{@class}"
end

post "/edit/:class/:id" do
  @id = params[:id]
  @class = params[:class]
  if @class == 'map'
    @nodes ||= {}
    $redis.keys("#{NAMESPACE}:map:#{@id}:node:*").each do |node|
      @nodes << $redis.hgetall(node).symbolize_keys
    end
    if params[:whname]
      @time = Time.now().to_i
      @newchild = {
        :time     => @time,
        :creator  => env['HTTP_EVE_CHARNAME'],
        :system   => env['HTTP_EVE_SOLARSYSTEMNAME'],
        :systemid => env['HTTP_EVE_SOLARSYSTEMID'],
        :security => system_meta(env['HTTP_EVE_SOLARSYSTEMID'])[:security].to_f,
        :parent   => @id,
      }
      h2r("#{NAMESPACE}:map:#{@id}:node:#{@time}", @newchild)
    end
  end
end
