#!/usr/bin/env ruby

require 'optparse'
require 'csv'
require 'time'

options = { :interpolations => 0 }

OptionParser.new do |opts|
  opts.banner = "Usage: convert_blender.rb --height 640 --width 640 --interpolations 3 --find-max-int --filename [filename]"

  opts.on("--height [ARG]", "Target Height") do |v|
    options[:height] = v
  end
  opts.on("--width [ARG]", "Target width") do |v|
    options[:width] = v
  end
  opts.on("--file [ARG]", "input file") do |v|
    options[:file] = v
  end
  opts.on("--interpolations [ARG]", "The number of interpolations required") do |v|
    options[:interpolations] = v.to_i
  end
  opts.on("--find-max-int", "Finds max interpolation value") do |v|
    options[:find_interpolation] = true
  end
end.parse!

def map(value, start1, stop1, start2, stop2)
  start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

def interpolation(x1,y1,x2,y2,interpolations)
  steps = Math.hypot(x2-x1, y2-y1).ceil
  #return if steps < 1

  0.upto(interpolations) { |x| puts "0,#{x1.to_i},#{y1.to_i}" } if steps < 1 && interpolations > 0
  return if steps < 1

  xstep = (x2-x1) / steps
  ystep = (y2-y1) / steps
  ips = 1
  ips = (interpolations / steps).floor if interpolations > 0
  
  #puts "ips: #{ips}, steps: #{steps}"
  counter = 0
  0.upto(steps) do |s|
    newx = x2 - (xstep * s)
    newy = y2 - (ystep * s)
    #next if x1 == newx && y1 == newy
    #next if x2 == newx && y2 == newy
    0.upto(ips) do |i|
      puts "0,#{newx.to_i},#{newy.to_i}"
      counter += 1
      break if counter > interpolations
    end
  end
end

maxinterpolation = 1

def max_interpolation(x1,y1,x2,y2,max,seq)
  mi = 0
  steps = Math.hypot(x2-x1, y2-y1).ceil
  xstep = (x2-x1) / steps
  ystep = (y2-y1) / steps
  0.upto(steps) do |s|
    newx = x2 - (xstep * s)
    newy = y2 - (ystep * s)
    next if x1 == newx && y1 == newy
    next if x2 == newx && y2 == newy
    mi += 1
  end
  if mi > 55
    puts "WARN #{x1.to_i},#{y1.to_i} and #{x2.to_i},#{y2.to_i} are #{mi} apart at seq #{seq}"
  end
  max = mi if mi > max
  max
end

file = options[:file] || "/Users/marshall/work/ruby/blender_export.csv"

#puts "x: [#{minx} - #{maxx}] y: [#{miny} - #{maxy}]"

px = -1
py = -1
maxi = 0
resets = 0
seq = 0

CSV.foreach(file, :col_sep => " ") do |row|
  ox = row[0].to_i
  oy = row[1].to_i
  x = map( row[0].to_f, 0, 1, 0.0, options[:width].to_f )
  y = map( row[1].to_f, 0, 1, 0.0, options[:height].to_f )

  if options[:find_interpolation]
    if ( ox == 1 && oy == 1 )
      px = py = -1
      resets += 1
      next
    end
    if ( px > -1 && py > -1 )
      maxi = max_interpolation(x, y, px, py, maxi, seq)
    end
  elsif ox == 1 && oy == 1
    resets += 1
    puts "1,1,1"
  else
    if ( px > -1 && py > -1 )
      interpolation(x, y, px, py, options[:interpolations])
    end
    puts "1,#{x.to_i},#{y.to_i}"
  end

  px = x
  py = y
  seq += 1
end

if options[:find_interpolation]
  puts "Max Interpolation: #{maxi}"
end


