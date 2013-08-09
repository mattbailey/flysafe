include Flysafe

def hash_to_haml(hash, level=0)
  result = [ "#{INDENT * level}%ul" ]
  hash.each do |key,value|
    result << "#{INDENT * (level + 1)}%li #{key}"
    result << hash_to_haml(value, level + 2) if value.is_a?(Hash)
  end
  result.join("\n")
end

def assets_to_list(assets, tempkey)
  out = []
  assets.each do |asset|
    if asset.container != {}
      out << assets_to_list(asset.container['contents'], tempkey)
    else
      @lid = asset.locationID
      if @lid.to_i >= 66000000 && @lid.to_i < 67000000
        @location = $redis.hgetall("#{NAMESPACE}:system:#{@lid.to_i - 6000001}", :solarSystemName)
      elsif @lid.to_i >= 67000000 && @lid.to_i < 68000000
        @location = $redis.hget("#{NAMESPACE}:system:#{@lid.to_i - 6000000}", :solarSystemName)
      elsif @lid.to_i > 60000000 && @lid.to_i < 61000000
        @location = $redis.hget("#{NAMESPACE}:stations:#{@lid.to_i}", :stationName)
      else
        @location = $redis.hget("#{NAMESPACE}:system:#{@lid.to_i}", :solarSystemName)
      end
      out << {
        :type => $redis.hget("#{NAMESPACE}:typecache", asset.typeID),
        :typeID => asset.typeID,
        :qty  => asset.quantity,
        :singleton => asset.singleton,
        :locationid => @lid,
        :location => @location
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
        haml_tag :td do
          haml_concat item[:locationid]
        end
      end
    end
  end
end
