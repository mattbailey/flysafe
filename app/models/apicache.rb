module Flysafe
  class API < EAAL::API
    def initialize(scope)
      self.keyid = $redis.hget "#{NAMESPACE}:config", "masterkeyid"
      self.vcode = $redis.hget "#{NAMESPACE}:config", "mastervcode"
      self.scope = scope
      return self
    end
  end
end

# From rails
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
