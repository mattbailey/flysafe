include Flysafe

def hash_to_haml(hash, level=0)
  result = [ "#{INDENT * level}%ul" ]
  hash.each do |key,value|
    result << "#{INDENT * (level + 1)}%li #{key}"
    result << hash_to_haml(value, level + 2) if value.is_a?(Hash)
  end
  result.join("\n")
end

def assets_to_list(assets)
  out = []
  assets.each do |asset|
    if asset.container != {}
      out << assets_to_list(asset.container['contents'])
    else
      out << {
        :type => $redis.hget("#{NAMESPACE}:typecache", asset.typeID),
        :typeID => asset.typeID,
        :qty  => asset.quantity,
        :singleton => asset.singleton,
        :location => asset.locationID
      }
    end
  end
  out
end

def array_to_haml(array)
  out = ""
  array.each do |item|
    if item.is_a? Array
      out << array_to_haml(item)
    else
      out << "null" 
    end
  end
end
