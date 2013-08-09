# encoding: UTF-8
require 'mysql'
require 'yaml'

my = Mysql::new("localhost", "root", "", "evewspace")
ss = my.query("select * from mapSolarSystems;")
f = File.new("systems.yml", "w")
ss_hash = {}

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
  ss_hash[hash['solarSystemID']] = hash.symbolize_keys
end

ss_hash.keys.each do |key|
  del = [:x, :y, :z, :xMin, :xMax, :yMin, :yMax, :zMin, :zMax, :luminosity, :international, :regional, :constellation, :factionID, :sunTypeID, :securityClass]
  del.each do |k|
    ss_hash[key].delete(k)
  end
end

ss_hash.keys.each do |key|
  ss_hash[key].keys.each do |attrib|
    unless attrib == :solarSystemName
      ss_hash[key][attrib] = eval(ss_hash[key][attrib])
    end
  end
end

ss_hash.keys.each do |key|
  ss_hash[key.to_i] = ss_hash[key]
  ss_hash.delete(key)
end

ss_hash.keys.each do |key|
  ss_hash[key][:solarSystemName].force_encoding "UTF-8"
end

f.write(ss_hash.to_yaml)
