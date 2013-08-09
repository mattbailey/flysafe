class Service

  attr_reader :services
  attr_reader :servers
  attr_reader :server_mapping
  DEAD_SERVER_AFTER = 60 * 20 #After 15 minutes without keep alives a server is considered dead ...

  def self.services_for session
    s = Service.new(session).load
    [s.services, s.servers, s.server_mapping]  
  end

  def initialize(redis_session = 'backend')
    @server_mapping = {}
    @servers = []
    @services = []
    @redis = $redis_sessions[redis_session]
  end

  def load

    @servers = @redis.smembers('backend_servers')
    return self unless @servers && !@servers.empty?
      
    @servers = @servers.to_a.sort #resort
    
    @server_mapping = {}
    @servers.each do |s|
      server = {}
      
      server['hbeat'] = load_hbeat(s)
      next unless server['hbeat'] #server is gone
      
      server['load']     = load_uptime(s)
      server['memory']   = load_memory(s)
      server['services'] = load_services(s)
      
      @server_mapping[s] = server
    end
    
    @servers.reject!{|s| @server_mapping[s].nil?}
    @services.uniq!
    self
  end

  def command server, service, command

    
    raise "missing parameter" unless server && command
    
    payload = {:data => {:command => command, :service => service}}
    @redis.lpush("_#{server}", payload.to_json)

    true
  end

  private
    def load_uptime server
      result = {}
      result['uptime'] = @redis.hget(server, 'uptime')
      result['status'] = 'important'
      
      if result['uptime']
        uptime = result['uptime'].split(',')[0]
        if uptime.to_f <= 3.0
          result['status']='' 
        elsif uptime.to_f <= 6.0
          result['status']='warning' 
        end
      end

      result
    rescue
      result
    end
    
    def load_hbeat server
      hbeat = @redis.hget(server, 'hbeat')
      
      return nil if hbeat.nil? || ((Time.now.utc.to_i - hbeat.to_i) > DEAD_SERVER_AFTER)
          
      Time.at(hbeat.to_i).strftime("%m/%d %H:%M:%S")
    rescue
      hbeat
    end
    
    def load_memory server
      result = {}
      
      memory = @redis.hget(server, 'mem')
      if memory
        mem         = memory.split(":")
        mem_avail   = mem[1].to_i*100/mem[0].to_i
        swap_avail  = mem[3].to_i*100/mem[2].to_i
        
        result['mem']    = "Mem: #{mem[1]}M (#{mem_avail}%)"
        result['swap']   = "Swap: #{mem[3]}M (#{swap_avail}%)"
        result['status'] ='warning' if mem_avail < 30 || swap_avail < 30
        result['status'] ='important' if mem_avail < 10 || swap_avail < 10
      end
      
      result
    rescue
      result
    end
    
    def load_services(server)
      result = {}
      _services = @redis.hget(server, 'services')
      result['name']= []
      result['avail'] = []
      
      if _services
        _services = _services.split(':').sort
        _services.each do |service_name|
          @services << service_name
          result['avail'] << service_name
          status = @redis.hget(server, "_#{service_name}")
          
          result['name'] << service_name  if status && status.to_i != -1
        end
      end
      
      result
    rescue
      result
    end
end