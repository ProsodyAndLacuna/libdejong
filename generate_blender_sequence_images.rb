#!/usr/bin/env ruby

require 'optparse'
require 'csv'
require './lib/libdejong'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: convert_wii.rb --data [directory] --out [directory] -f [filename]"

  opts.on("--data [ARG]", "Input Data") do |v|
    options[:data] = v
  end
  opts.on("--out [ARG]", "Output Directory") do |v|
    options[:output] = v
  end
  opts.on("-f [ARG]", "input file") do |v|
    options[:file] = v
  end
end.parse!


file = options[:file] 
seq = 0


CSV.foreach(file, :col_sep => ",") do |row|
  recorded = row[0].to_i
  x = row[1].to_i
  y = row[2].to_i
  p = LibDeJong::Point.new x, y
  fname = File.join( options[:data], "dejong-1024-#{p.to_filename_part}.json" )

  if File.exists? fname 
    frame = LibDeJong::FrameWriter.read_raw( fname )

    oname = "#{seq.to_s.rjust(10, '0')}-#{p.to_filename_part}-#{recorded}"
    LibDeJong::FrameWriter.write frame, options[:output], ChunkyPNG::Color::BLACK, 255, oname
  else
    p "#{fname} doesnt exist, unable to create frame #{seq}"
  end
  seq += 1
end


