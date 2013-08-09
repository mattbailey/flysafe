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
  array.each do |item|
    haml_tag :tr do
      if item.is_a? Array
        array_to_haml(item)
      else
        haml_tag :td do
          haml_concat item[:type]
        end
        haml_tag :td do
          haml_concat item[:qty]
        end
        haml_tag :td do
          haml_concat item[:location]
        end
      end
    end
  end
end
