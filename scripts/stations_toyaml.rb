# encoding: UTF-8
require 'mysql'
require 'yaml'

my = Mysql::new("localhost", "root", "", "evewspace")
conv = my.query("ALTER TABLE staStations CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;")
ss = my.query("select * from staStations;")
f = File.new("stations.yml", "w")
s_hash = {}

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

ss.each_hash do |hash|
  s_hash[hash['stationID']] = hash.symbolize_keys
end

s_hash.keys.each do |key|
  del = [:x, :y, :z, :dockingCostPerVolume, :maxShipVolumeDockable, :operationID, :stationTypeID, :corporationID, :constellationID, :reprocessingEfficiency, :reprocessingStationsTake, :reprocessingHangarFlag]
  del.each do |k|
    s_hash[key].delete(k)
  end
end

s_hash.keys.each do |key|
  s_hash[key].keys.each do |attrib|
    unless attrib == :stationName
      s_hash[key][attrib] = eval(s_hash[key][attrib])
    end
  end
end

s_hash.keys.each do |key|
  s_hash[key.to_i] = s_hash[key]
  s_hash.delete(key)
end

s_hash.keys.each do |key|
  s_hash[key][:stationName].force_encoding "UTF-8"
end

f.write(s_hash.to_yaml)
