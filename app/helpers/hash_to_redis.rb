def h2r(key, hash)
  hash.keys.each do |hkey|
    $redis.hset(key, hkey, hash[hkey])
  end
end
