require 'sinatra'
require 'sinatra/static_assets'
require 'haml'
require 'redis'
require 'hiredis'
require 'yaml'
require 'sinatra/flash'
require 'json'
require 'sinatra/redirect_with_flash'
require 'eaal'
require 'digest/sha1'

@redis_config = YAML.load_file('./config/redis.yml')

NAMESPACE = @redis_config[:namespace]
$redis = Redis.new(@redis_config[Sinatra::Base.environment])

class Hash
  def transform_keys
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end
  def symbolize_keys
    transform_keys{ |key| key.to_sym rescue key }
  end
end


Dir["./app/models/*.rb"].each { |file| require file }
Dir["./app/helpers/*.rb"].each { |file| require file }
Dir["./app/controllers/*.rb"].each { |file| require file }
