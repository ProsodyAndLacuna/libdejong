#!/usr/bin/env ruby

require 'optparse'
require 'csv'
require 'time'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: convert_wii.rb -h 640 -w 640 -f [filename]"

  opts.on("-h [ARG]", "Target Height") do |v|
    options[:height] = v
  end
  opts.on("-w [ARG]", "Target width") do |v|
    options[:width] = v
  end
  opts.on("-f [ARG]", "input file") do |v|
    options[:file] = v
  end
end.parse!

def map(value, start1, stop1, start2, stop2)
  start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

file = options[:file] || "/Users/marshall/work/ruby/dejong-generator/wii.dat"

maxx = 0
minx = 0
maxy = 0
miny = 0

CSV.foreach(file) do |row|
  #x = map( row[1].to_f, -1.25, 1.25, 0.0, options[:width].to_f )
  #y = map( row[2].to_f, -0.75, 3.00, 0.0, options[:height].to_f )
  x = row[1].to_f
  y = row[2].to_f
  
  maxx = x if x > maxx
  minx = x if x < minx
  maxy = y if y > maxy
  miny = y if y < miny
end

#puts "x: [#{minx} - #{maxx}] y: [#{miny} - #{maxy}]"

pt = nil
CSV.foreach(file, :headers => true) do |row|
  x = map( row[1].to_f, minx, maxx, 0.0, options[:width].to_f )
  y = map( row[2].to_f, miny, maxy, 0.0, options[:height].to_f )
  z = row[3].to_f
  x = options[:width].to_f - x if z > 0
  y = options[:height].to_f - y if x > 0
  t = Time.parse row[0]
  dt = 0
  dt = t - pt if pt
  pt = t
  puts "#{dt},#{x.to_i},#{y.to_i}"
end

