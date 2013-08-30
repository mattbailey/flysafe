def delete_item(cls, id)
  if cls == 'map'
    $redis.del("#{NAMESPACE}:map:#{id}")
  end
end
