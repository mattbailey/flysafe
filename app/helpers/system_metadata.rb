def system_meta(systemid)
  return $redis.hgetall("#{NAMESPACE}:system:#{systemid}").symbolize_keys
end
