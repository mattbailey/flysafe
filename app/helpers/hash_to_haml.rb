def location_get(lid)
  if lid >= 66000000 && lid < 67000000
    $redis.hgetall("#{NAMESPACE}:system:#{lid - 6000001}", :solarSystemName)
  elsif lid >= 67000000 && lid < 68000000
    $redis.hget("#{NAMESPACE}:system:#{lid - 6000000}", :solarSystemName)
  elsif lid > 60000000 && lid < 61000000
    $redis.hget("#{NAMESPACE}:stations:#{lid}", :stationName)
  else
    $redis.hget("#{NAMESPACE}:system:#{lid}", :solarSystemName)
  end
end

def asset_haml_station(assets)
  haml_tag 'div.panel' do
    haml_tag 'div.panel-heading' do
      haml_tag :b do
        haml_concat "Items not in a container"
      end
    end
    assets.each do |asset|
      # no containers allowed here
      if asset.container == {}
        haml_tag 'div.row' do
          haml_tag 'div.col-lg-1' do
            haml_concat asset.quantity
          end
          haml_tag 'div.col-lg-4' do
            haml_concat $redis.hget("#{NAMESPACE}:typecache", asset.typeID)
          end
          haml_tag 'div.col-lg-4' do
            haml_concat location_get(asset.locationID.to_i)
          end
        end
      end
    end
  end
end

def asset_haml(assets)
  assets.each do |asset|
    unless asset.container == {}
      haml_tag 'div.panel' do
        haml_tag 'div.panel-heading' do
          haml_tag :b do
            haml_concat "#{location_get(asset.locationID.to_i)} #{$redis.hget("#{NAMESPACE}:typecache", asset.typeID)}"
          end
        end
        asset_haml(asset.container['contents'])
      end
    else
      if asset.locationID.nil?
        haml_tag 'div.row' do
          haml_tag 'div.col-lg-1' do
            haml_concat asset.quantity
          end
          haml_tag 'div.col-lg-4' do
            haml_concat $redis.hget("#{NAMESPACE}:typecache", asset.typeID)
          end
        end
      end
    end
  end
end
