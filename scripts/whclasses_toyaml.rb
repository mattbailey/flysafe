# encoding: UTF-8
require 'rubygems'
require 'mysql'
require 'yaml'

my = Mysql::new("localhost", "root", "", "evewspace")
conv = my.query("ALTER TABLE mapLocationWormholeClasses CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;")
ss = my.query("select * from mapLocationWormholeClasses;")
f = File.new("wh_classes.yml", "w")
s_list = []

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

ss.each do |item|
  s_list << {item[0].to_i => item[1].to_i}
end

f.write(s_list.to_yaml)
