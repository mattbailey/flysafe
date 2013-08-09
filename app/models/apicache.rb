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
